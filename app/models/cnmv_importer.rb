class CnmvImporter < Importer
  def initialize()
    super(source_name: 'Nombre', role_name: 'Cargo', target_name: 'Empresa')
    @preprocessor = ->(fact) { split_multiple_roles(fact) }
  end

  def split_multiple_roles(fact)
    if fact.properties[@role_name].index('-')
      first_role, second_role = fact.properties[@role_name].split('-')
      new_fact = fact.dup.tap {|f| f.properties[@role_name] = second_role.strip }
      fact.properties[@role_name] = first_role.strip
      return [fact, new_fact]
    end
    fact
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
end
