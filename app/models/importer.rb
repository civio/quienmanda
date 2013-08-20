class Importer
  attr_reader :matched_entities, :matched_relation_types, :results, :event_log
  attr_accessor :preprocessor

  def initialize(source_name: :source, role_name: :role, target_name: :target)
    @preprocessor = nil
    @source_name = source_name
    @role_name = role_name
    @target_name = target_name
  end

  def match(facts)
    @event_log = []
    @match_results = []
    @matched_entities = {}
    @matched_relation_types = {}
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
    @match_results
  end

  private

  def process_match_result(fact, match_result)
    create_relation(fact, match_result)
    match_result.merge(fact: fact)
  end

  def create_relation(fact, match_result)
    # TODO: Move basic/reusable code from CNMV importer here. Do nothing for now
  end

  def match_properties(properties)
    # Check whether we've seen this datum before
    role = properties[@role_name]
    if @matched_relation_types[role]
      @matched_relation_types[role][:count] += 1

    else  # Try to find an existing RelationType matching the imported data
      relation_type = match_relation_type(role)
      @matched_relation_types[role] = { count: 1, object: relation_type }
    end


    # Check whether we've seen this datum before
    source = properties[@source_name]
    if @matched_entities[source]
      @matched_entities[source][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = match_source_entity(source)
      @matched_entities[source] = { count: 1, object: relation_type }
    end


    # Check whether we've seen this datum before
    target = properties[@target_name]
    if @matched_entities[target]
      @matched_entities[target][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = match_target_entity(target)
      @matched_entities[target] = { count: 1, object: relation_type }
    end

    # Return matched data
    {
      source: @matched_entities[source][:object],
      target: @matched_entities[target][:object],
      relation_type: @matched_relation_types[role][:object]
    }
  end

  def match_relation_type(relation_type)
    relation_type && RelationType.find_by(["lower(description) = ?", relation_type.downcase])
  end

  def match_source_entity(source)
    source && Entity.find_by(["lower(name) = ?", source.downcase])
  end

  def match_target_entity(target)
    target && Entity.find_by(["lower(name) = ?", target.downcase])
  end

  # Event logging convenience methods
  def info(fact, message)
    @event_log << { severity: :info, fact: fact, message: message }
  end

  def warn(fact, message)
    @event_log << { severity: :warning, fact: fact, message: message }
  end
end