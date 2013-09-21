class Importer
  attr_reader :source_field, :role_field, :target_field, :create_missing_entities
  attr_reader :matched_entities, :matched_relation_types, :results, :event_log
  attr_accessor :preprocessor

  def initialize(source_field: :source, role_field: :role, target_field: :target, create_missing_entities: false)
    @preprocessor = nil
    @source_field = source_field
    @role_field = role_field
    @target_field = target_field
    @create_missing_entities = create_missing_entities
  end

  def match(facts, dry_run: false)
    @event_log = []
    @match_results = []
    @matched_entities = {}
    @matched_relation_types = {}
    Fact.transaction do
      facts.each do |fact|
        # Process all records, and add a reference to the original input Fact
        if preprocessor
          processed_props = preprocessor.call(fact.properties)
          # This is a bit convoluted because the preprocessor can return one or many items
          processed_props = [processed_props] unless processed_props.kind_of?(Array)
          processed_props.each do |props| 
            @match_results << process_match_result(fact, match_properties(props))
          end
        else
          @match_results << process_match_result(fact, match_properties(fact.properties))
        end
      end
      raise ActiveRecord::Rollback if dry_run
    end
    @match_results
  end

  private

  def process_match_result(fact, match_result)
    create_relation(fact, match_result)
    match_result.merge(fact: fact)
  end

  def match_properties(properties)
    # Check whether we've seen this datum before
    role_name = properties[@role_field]
    if @matched_relation_types[role_name]
      @matched_relation_types[role_name][:count] += 1
    else  # Try to find an existing RelationType matching the imported data
      role = match_relation_type(role_name)
      @matched_relation_types[role_name] = { count: 1, object: role }
    end

    # Check whether we've seen this datum before
    source_name = properties[@source_field]
    if @matched_entities[source_name]
      @matched_entities[source_name][:count] += 1
    else  # Try to find an existing Entity matching the imported data
      source = match_source_entity(source_name)
      @matched_entities[source_name] = { count: 1, object: source }
    end

    # Check whether we've seen this datum before
    target_name = properties[@target_field]
    if @matched_entities[target_name]
      @matched_entities[target_name][:count] += 1
    else  # Try to find an existing Entity matching the imported data
      target = match_target_entity(target_name)
      @matched_entities[target_name] = { count: 1, object: target }
    end

    # Return matched data
    {
      source: @matched_entities[source_name][:object],
      target: @matched_entities[target_name][:object],
      relation_type: @matched_relation_types[role_name][:object]
    }
  end

  def create_entity(attributes)
    # TODO: Move basic/reusable code from CNMV importer here. Do nothing for now
  end

  def create_relation(fact, match_result)
    # TODO: Move basic/reusable code from CNMV importer here. Do nothing for now
  end

  def match_relation_type(relation_type)
    relation_type && RelationType.find_by(["lower(description) = ?", relation_type.downcase])
  end

  def match_entity(entity_name)
    entity_name && Entity.find_by(["lower(name) = ?", entity_name.downcase])
  end

  def match_or_create_entity(entity_name, create_arguments)
    entity = match_entity(entity_name)
    if entity.nil? and @create_missing_entities # Create entity if needed
      entity = create_entity( create_arguments.merge({name: entity_name}) )
    end
    entity
  end

  # We keep two separate source/target to allow easier override in child classes
  def match_source_entity(source)
    match_or_create_entity(source, {})
  end
  def match_target_entity(target)
    match_or_create_entity(target, {})
  end

  # Event logging convenience methods
  def info(fact, message)
    @event_log << { severity: :info, fact: fact, message: message }
  end

  def warn(fact, message)
    @event_log << { severity: :warning, fact: fact, message: message }
  end
end