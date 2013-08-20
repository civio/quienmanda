class CnmvImporter < Importer
  attr_reader :event_log  # TODO: Move this to base class

  SOURCE_NAME = 'Nombre'
  ROLE_NAME = 'Cargo'
  TARGET_NAME = 'Empresa'

  def initialize()
    super(source_name: SOURCE_NAME, role_name: ROLE_NAME, target_name: TARGET_NAME)
    @preprocessor = ->(fact) { _split_multiple_roles(_canonical_person_name(fact)) }
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
              ["lower(description) = ?", "#{description}/a"],
              ["lower(description) = ?", "#{description}/a de"] ]
    tries.each do |try|
      object = RelationType.find_by(try)
      return object if not object.nil?
    end
    nil
  end

  def match_source_entity(source)
    _match_entity(source)
  end

  def match_target_entity(target)
    _match_entity(target)
  end

  def create_missing_objects
    clear_event_log
    # For each matched fact result
    @results.each do |result|
      fact = result[:fact]

      # Do nothing if the relation type is unknown
      if result[:relation_type].nil?
        warn(result, "Skipping unknown relation type '#{fact.properties[ROLE_NAME]}'...")
        next
      end

      # Do nothing if this fact has already been imported, i.e. already has relations
      if not fact.relations.empty?
        warn(result, "Skipping fact ##{fact.id}, already has relations...")
        next
      end

      # Create source/target entities if needed
      if result[:source].nil?
        result[:source] = create_entity(name: fact.properties[SOURCE_NAME])
        info(result, "Created person '#{result[:source].name}'")
      end
      if result[:target].nil?
        # FIXME: Will keep creating the entity again and again
        result[:target] = create_entity(name: fact.properties[TARGET_NAME], person: false)
        info(result, "Created organization '#{result[:target].name}'")
      end

      # Get basic relation data
      attributes = {source: result[:source], 
                    relation_type: result[:relation_type],
                    target: result[:target]}

      # If needed, create the relation associated to the fact. Otherwise, edit existing one
      if relation = Relation.where(attributes).first
        # Reusing an existing relation, make sure it points to the current fact
        fact.relations << relation
        fact.save!
        info(result, "Updating relation: #{relation.to_s}")
      else
        # Create a new relation from scratch
        relation = fact.relations.create!(attributes)
        info(result, "Created relation: #{relation.to_s}")
      end

      # Add additional information, if available
      if from_date = fact.properties['Fecha Nombramiento']
        # TODO: Do not overwrite manually entered stuff? + Warning
        relation.from = Date.strptime(from_date, '%d/%m/%Y')
        relation.save!
      end
    end
  end

  # Guess whether a given name relates to a company or a person
  def is_a_person(name)
    return false if name =~ /s\.[al]\./i  # Check for S.A. or S.L.
    return false if name =~ /n\.v\.$/i    # Check for trailing N.V. (dutch)
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
    # Clean up the entity name a bit
    name = UnicodeUtils.titlecase(attributes[:name])  # Titlecase respecting accented characters
    name.gsub!('S.a.', 'S.A.')                        # Cosmetic: uppercase trailing S.A.
    name.gsub!('S.l.', 'S.L.')                        # Cosmetic: uppercase trailing S.L.
    name.gsub!('N.v.', 'N.V.')                        # Cosmetic: uppercase trailing N.V.
    name.gsub!('´', '\'')                             # Get rid of ´, see note in test

    # Create the entity with values when specified (and with defaults otherwise)
    is_a_person = attributes[:person] || is_a_person(name)
    # FIXME: Overrideable defaults: person: false, needs_work: true, priority: 2, published: false
    Entity.create!(name: name, priority: 2, person: is_a_person)
  end

  # TODO: Move this to base class
  def clear_event_log
    @event_log = []
  end

  def info(result, message)
    @event_log << { severity: :info, result: result, message: message }
  end

  def warn(result, message)
    @event_log << { severity: :warning, result: result, message: message }
  end
end
