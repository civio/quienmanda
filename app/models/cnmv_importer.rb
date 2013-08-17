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
    return nil if source.nil?
    name = source.downcase

    tries = [ ["lower(name) = ?", name], 
              ["lower(short_name) = ?", name],
              ["lower(unaccent(name)) = ?", name],
              ["lower(unaccent(short_name)) = ?", name] ]
    tries.each do |try|
      object = Entity.find_by(try)
      return object if not object.nil?
    end
    nil
  end

  private

  # Convert fact names of the type "Surname, Name" into "Name Surname"
  def _canonical_person_name(fact)
    if fact.properties[@source_name] && fact.properties[@source_name].index(',')
      # Careful with company names as board members though (trailing S.A., S.L., ...)
      if fact.properties[@source_name].index(' S.') == nil
        surname, name = fact.properties[@source_name].split(',')
        fact.properties[@source_name] = "#{name.strip} #{surname.strip}"
      end
    end
    fact
  end

  # Split facts with relations of the type "roleA - roleB"
  def _split_multiple_roles(fact)
    if fact.properties[@role_name] && fact.properties[@role_name].index('-')
      first_role, second_role = fact.properties[@role_name].split('-')
      new_fact = fact.dup.tap {|f| f.properties[@role_name] = second_role.strip }
      fact.properties[@role_name] = first_role.strip
      return [fact, new_fact]
    end
    fact
  end
end
