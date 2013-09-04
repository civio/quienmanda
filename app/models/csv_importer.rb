# FIXME: Lots of duplication with CNMVImporter, need to make that extend this
class CsvImporter < Importer
  COMPANY_ENDINGS = [/(, S\.A\.)/i, /(, S\.L\.)/i, /(, N\.V\.)/i]

  def initialize(source_name: 'source', role_name: 'role', target_name: 'target', create_missing_entities: false)
    super(source_name: source_name, role_name: role_name, target_name: target_name)
    @create_missing_entities = create_missing_entities
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
      warn(fact, "Skipping fact, unknown relation type '#{fact.properties[role_name]}'...")
      return
    end
    if match_result[:source].nil?
      warn(fact, "Skipping fact, unknown source entity '#{fact.properties[source_name]}'...")
      return
    end
    if match_result[:target].nil?
      warn(fact, "Skipping fact, unknown target entity '#{fact.properties[target_name]}'...")
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
  end

  # Guess whether a given name relates to a company or a person
  def is_a_person(name)
    COMPANY_ENDINGS.each {|regex| return false if name =~ regex }
    true
  end

  private

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
    priority = attributes[:priority] || Entity::PRIORITY_MEDIUM
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
