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

    @fuzzy_matcher = nil
  end

  def match(facts, dry_run: false, matching_threshold: 1)
    @event_log = []
    @match_results = []
    @matched_entities = {}
    @matched_relation_types = {}

    # We take threshold = 1 to be exact matching, fuzzy matching below that
    @fuzzy_matcher = build_fuzzy_matcher if matching_threshold < 1
    @fuzzy_matching_threshold = matching_threshold

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

  # Creates a Fuzzy Matcher containing the names of all existing entities
  def build_fuzzy_matcher()
    # Since entities can have more than one name, and FuzzyMatch expects just one,
    # we'll use an intermediate mapping table.
    names = {}
    Entity.all.each do |entity|
      names[entity.name] = entity
      names[entity.short_name] = entity
    end
    FuzzyMatch.new names, :read => 0  # 0: first element, i.e. key
  end

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

  def fuzzy_match_entity(entity_name)
    result, score = @fuzzy_matcher.find_with_score(entity_name, must_match_at_least_one_word: true)
    return nil if result.nil? or score < @fuzzy_matching_threshold

    # I'd like to return to make the score data available to controller, 
    # but cumbersome: storing it as a non-persistent attribute of the entity
    # is a bad solution, since the same entity can be used a number of times
    # during an import. I'd need to propagate score all the way up to Importer,
    # and modify the exact matching functions to return '1' as confidence.
    result[1]
  end

  def match_or_create_entity(entity_name, create_arguments)
    entity = @fuzzy_matcher ? fuzzy_match_entity(entity_name) : match_entity(entity_name)
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