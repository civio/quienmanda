class Importer
  attr_accessor :entities, :relation_types

  def initialize
    @entities = {}
    @relation_types = {}
  end

  def match(fact)
    # Check whether we've seen this datum before
    role = fact.properties['Cargo']
    if @relation_types[role]
      @relation_types[role][:count] += 1

    else  # Try to find an existing RelationType matching the imported data
      relation_type = RelationType.find_by(["lower(description) = ?", role.downcase])
      @relation_types[role] = { count: 1, relation_type: relation_type }
    end


    # Check whether we've seen this datum before
    source = fact.properties['Nombre']
    if @entities[source]
      @entities[source][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = Entity.find_by(["lower(name) = ?", source.downcase])
      @entities[source] = { count: 1, relation_type: relation_type }
    end


    # Check whether we've seen this datum before
    target = fact.properties['Empresa']
    if @entities[target]
      @entities[target][:count] += 1

    else  # Try to find an existing Entity matching the imported data
      relation_type = Entity.find_by(["lower(name) = ?", target.downcase])
      @entities[target] = { count: 1, relation_type: relation_type }
    end
  end
end