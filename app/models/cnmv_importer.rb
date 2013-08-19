class CnmvImporter < Importer
  def initialize()
    super(source_name: 'Nombre', role_name: 'Cargo', target_name: 'Empresa')
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
end
