class CnmvImporter < CsvImporter
  def initialize(create_missing_entities: false)
    super(source_field: 'Nombre', 
          role_field: 'Cargo', 
          target_field: 'Empresa',
          create_missing_entities: create_missing_entities)
    @preprocessor = ->(fact) { _split_multiple_roles(_canonical_entity_name(fact)) }
  end

  def match_relation_type(relation_type)
    return nil if relation_type.nil?
    # Downcasing here won't handle accented character correctly, but we
    # don't want to lose the accent data (using Stringex to_ascii) just yet
    description = relation_type.downcase

    # Remove some useless additional detail
    description.gsub!(/vicepresidente .+/, 'vicepresidente')
    description.gsub!(/(vice)?secretario consejero/, 'consejero')
    description.gsub!(/copresidente/, 'presidente')

    # Try to find the relation type in the database
    tries = [ ["lower(description) = ?", description], 
              ["lower(unaccent(description)) = ?", description.to_ascii.downcase],
              ["lower(description) = ?", "#{description} de"],
              ["lower(description) = ?", "#{description}/a"],
              ["lower(description) = ?", "#{description}/a de"] ]
    tries.each do |try|
      object = RelationType.find_by(try)
      return object if not object.nil?
    end
    nil
  end

  # Override this method to ensure targets are always companies (we know that)
  def match_target_entity(target)
    match_or_create_entity(target, { person: false })
  end

  # Add additional information, if available
  def populate_extra_relation_attributes(relation, fact)
    if from_date = fact.properties['Fecha Nombramiento']
      # TODO: Do not overwrite manually entered stuff? + Warning
      relation.from = Date.strptime(from_date, '%d/%m/%Y')
      relation.save!
    end
  end

  private

  def _canonical_entity_name(properties)
    _canonical_company_name(_canonical_person_name(properties))
  end

  # Convert fact names of the type "Surname, Name" into "Name Surname"
  def _canonical_person_name(properties)
    if properties[@source_field] && properties[@source_field].index(',')
      # Careful with company names as board members though (trailing S.A., S.L., ...)
      if properties[@source_field].index(' S.') == nil
        surname, name = properties[@source_field].split(',')
        return properties.clone.tap {|props| props[@source_field] = "#{name.strip} #{surname.strip}"}
      end
    end
    properties
  end

  # Clean up the trailing S.A., sometimes incomplete in CNMV listings
  def _canonical_company_name(properties)
    if properties[@target_field] =~ /S\.A$/i # Could be more flexible, but will do for now
      return properties.clone.tap {|props| props[@target_field] += '.' }
    end
    properties
  end

  # Split facts with relations of the type "roleA - roleB"
  def _split_multiple_roles(properties)
    if properties[@role_field] && properties[@role_field].index('-')
      first_role, second_role = properties[@role_field].split('-')
      new_properties = properties.clone.tap {|p| p[@role_field] = second_role.strip }
      ammended_properties = properties.clone.tap {|p| p[@role_field] = first_role.strip }
      return [ammended_properties, new_properties]
    end
    properties
  end
end
