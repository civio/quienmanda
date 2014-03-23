class CsvImporter < Importer
  COMPANY_ENDINGS = [/(, ?S\.A\.)$/i, /(,? S\.L\.)$/i, /(,? N\.V\.)$/i]

  def initialize(source_field: 'source', role_field: 'role', target_field: 'target', create_missing_entities: false)
    super(source_field: source_field, 
          role_field: role_field, 
          target_field: target_field, 
          create_missing_entities: create_missing_entities)
  end

  def create_relation(fact, match_result)
    # Do nothing if we're missing one of the basic elements of a relation
    if match_result[:relation_type].nil?
      warn(fact, "Skipping fact, unknown relation type '#{fact.properties[role_field]}'...")
      return
    end
    if match_result[:source].nil?
      warn(fact, "Skipping fact, unknown source entity '#{fact.properties[source_field]}'...")
      return
    end
    if match_result[:target].nil?
      warn(fact, "Skipping fact, unknown target entity '#{fact.properties[target_field]}'...")
      return
    end

    # Get basic relation data
    attributes = {source: match_result[:source], 
                  relation_type: match_result[:relation_type],
                  target: match_result[:target],
                  published: true}

    # If needed, create the relation associated to the fact. Otherwise, edit existing one
    if relation = Relation.where(attributes).first
      # Reusing an existing relation, make sure it points to the current fact
      fact.relations << relation unless fact.relations.exists?(id: relation.id)
      info(fact, "Updating relation: #{relation.to_s}")
    else
      # Create a new relation from scratch
      relation = fact.relations.create!(attributes)
      info(fact, "Created relation: #{relation.to_s}")
    end

    populate_extra_relation_attributes(relation, fact)
  end

  # Placeholder for children classes to override
  # TODO: Do not overwrite manually entered stuff? and/or warning if conflict
  def populate_extra_relation_attributes(relation, fact)
    if from_date = fact.properties['from']
      relation.from = Date.strptime(from_date, '%d/%m/%Y')
    end
    if to_date = fact.properties['to']
      relation.to = Date.strptime(to_date, '%d/%m/%Y')
    end
    if at_date = fact.properties['at']
      relation.at = Date.strptime(at_date, '%d/%m/%Y')
    end
    relation.save! if relation.changed?    
  end

  # Guess whether a given name relates to a company or a person
  def is_a_person(name)
    COMPANY_ENDINGS.each {|regex| return false if name =~ regex }
    true
  end

  private

  # Exact matching method aware of accented characters. This may not be
  # needed anymore if fuzzy matching is reliable enough and becomes standard.
  def match_entity(entity)
    return nil if entity.nil?
    # Downcasing here won't handle accented character correctly, but we
    # don't want to lose the accent data (using Stringex to_ascii) just yet
    name = entity.strip.downcase

    tries = [ ["lower(name) = ?", name], 
              ["lower(short_name) = ?", name],
              ["lower(unaccent(name)) = ?", name.to_ascii.downcase],
              ["lower(unaccent(short_name)) = ?", name.to_ascii.downcase] ]
    tries.each do |try|
      object = Entity.find_by(try)
      return object if not object.nil?
    end
    nil
  end

  # TODO: Probably move the entity-creation-related code to base class
  def create_entity(attributes)
    name = attributes[:name].strip
    if name.blank?
      warn(nil, "Skipping entity with blank name...")
      return nil
    end

    # Clean up the entity name a bit
    short_name = nil
    name = UnicodeUtils.titlecase(name) # Titlecase respecting accented characters
    name.gsub!('´', '\'')               # Get rid of ´, see note in test
    COMPANY_ENDINGS.each do |regex|     # Uppercase trailing S.A., S.L...
      if name =~ regex
        match = $1
        short_name = name.gsub(match, '')
        name.gsub!(match, match.upcase)
        break
      end
    end

    # Create the entity with values when specified (and with defaults otherwise)
    # TODO: It probably makes more sense to clone the original Hash and fill it in
    is_a_person = attributes[:person].nil? ? is_a_person(name) : attributes[:person]
    priority = attributes[:priority] || Entity::PRIORITY_MEDIUM
    needs_work = attributes[:needs_work].nil? ? true : attributes[:needs_work]
    published = attributes[:published].nil? ? true : attributes[:published]
    entity = Entity.create!(name: name, 
                            short_name: short_name,
                            priority: priority, 
                            person: is_a_person,
                            needs_work: needs_work,
                            published: published)
    # TODO: Missing fact here
    info(nil, "Created #{is_a_person ? 'person' : 'organization'} '#{entity.short_or_long_name}'")
    entity
  end
end
