class CnmvImporter < Importer
  SOURCE_NAME = 'Nombre'
  ROLE_NAME = 'Cargo'
  TARGET_NAME = 'Empresa'

  COMPANY_ENDINGS = [/(, S\.A\.)/i, /(, S\.L\.)/i, /(, N\.V\.)/i]

  def initialize(create_missing_entities: false)
    super(source_name: SOURCE_NAME, role_name: ROLE_NAME, target_name: TARGET_NAME)
    @preprocessor = ->(fact) { _split_multiple_roles(_canonical_person_name(fact)) }
    @create_missing_entities = create_missing_entities
  end

  def match_relation_type(relation_type)
    return nil if relation_type.nil?
    description = relation_type.downcase

    # Remove some useless additional detail
    description.gsub!(/vicepresidente .+/, 'vicepresidente')
    description.gsub!(/(vice)?secretario consejero/, 'consejero')
    description.gsub!(/copresidente/, 'presidente')

    # Try to find the relation type in the database
    tries = [ ["lower(description) = ?", description], 
              ["lower(description) = ?", "#{description} de"],
              ["lower(description) = ?", "#{description}/a"],
              ["lower(description) = ?", "#{description}/a de"] ]
    tries.each do |try|
      object = RelationType.find_by(try)
      return object if not object.nil?
    end
    nil
  end

  def match_source_entity(source)
    entity = _match_entity(source)
    if entity.nil? and @create_missing_entities # Create entity if needed
      entity = create_entity(name: source)
    end
    entity
  end

  def match_target_entity(target)
    entity = _match_entity(target)
    if entity.nil? and @create_missing_entities # Create entity if needed
      entity = create_entity(name: target, person: false)
    end
    entity
  end

  def create_relation(fact, match_result)
    # Do nothing if the we miss one of the basic elements of a relation
    if match_result[:relation_type].nil?
      warn(fact, "Skipping fact, unknown relation type '#{fact.properties[ROLE_NAME]}'...")
      return
    end
    if match_result[:source].nil?
      warn(fact, "Skipping fact, unknown source entity '#{fact.properties[SOURCE_NAME]}'...")
      return
    end
    if match_result[:target].nil?
      warn(fact, "Skipping fact, unknown target entity '#{fact.properties[TARGET_NAME]}'...")
      return
    end

    # Get basic relation data
    attributes = {source: match_result[:source], 
                  relation_type: match_result[:relation_type],
                  target: match_result[:target]}

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

    # Add additional information, if available
    if from_date = fact.properties['Fecha Nombramiento']
      # TODO: Do not overwrite manually entered stuff? + Warning
      relation.from = Date.strptime(from_date, '%d/%m/%Y')
      relation.save!
    end
  end

  # Guess whether a given name relates to a company or a person
  def is_a_person(name)
    COMPANY_ENDINGS.each {|regex| return false if name =~ regex }
    true
  end

  private

  # Convert fact names of the type "Surname, Name" into "Name Surname"
  def _canonical_person_name(properties)
    if properties[@source_name] && properties[@source_name].index(',')
      # Careful with company names as board members though (trailing S.A., S.L., ...)
      if properties[@source_name].index(' S.') == nil
        surname, name = properties[@source_name].split(',')
        return properties.clone.tap {|props| props[@source_name] = "#{name.strip} #{surname.strip}"}
      end
    end
    properties
  end

  # Split facts with relations of the type "roleA - roleB"
  def _split_multiple_roles(properties)
    if properties[@role_name] && properties[@role_name].index('-')
      first_role, second_role = properties[@role_name].split('-')
      new_properties = properties.clone.tap {|p| p[@role_name] = second_role.strip }
      ammended_properties = properties.clone.tap {|p| p[@role_name] = first_role.strip }
      return [ammended_properties, new_properties]
    end
    properties
  end

  def _match_entity(entity)
    return nil if entity.nil?
    # Downcasing here won't handle accented character correctly, but we
    # don't want to lose the accent data (using Stringex to_ascii) just yet
    name = entity.downcase

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
    priority = attributes[:priority] || :medium
    needs_work = attributes[:needs_work].nil? ? true : attributes[:needs_work]
    published = attributes[:published].nil? ? false : attributes[:published]
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
