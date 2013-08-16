class Importer
  attr_accessor :entities, :relation_types

  def initialize(source_name: :source, role_name: :role, target_name: :target)
    @entities = {}
    @relation_types = {}

    @source_name = source_name
    @role_name = role_name
    @target_name = target_name
  end

  def match(fact)
    # Check whether we've seen this datum before
    role = fact.properties[@role_name]
    if @relation_types[role]
      @relation_types[role][:count] += 1

    else  # Try to find an existing RelationType matching the imported data
      relation_type = RelationType.find_by(["lower(description) = ?", role.downcase])
      @relation_types[role] = { count: 1, object: relation_type }
    end


    # Check whether we've seen this datum before
    source = fact.properties[@source_name]
    if @entities[source]
      @entities[source][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = Entity.find_by(["lower(name) = ?", source.downcase])
      @entities[source] = { count: 1, object: relation_type }
    end


    # Check whether we've seen this datum before
    target = fact.properties[@target_name]
    if @entities[target]
      @entities[target][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = Entity.find_by(["lower(name) = ?", target.downcase])
      @entities[target] = { count: 1, object: relation_type }
    end

    # Return matched data
    {
      source: @entities[source][:object],
      target: @entities[target][:object],
      relation_type: @relation_types[role][:object]
    }
  end
end