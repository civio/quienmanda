class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # TODO: For now we'll just try importing all the data. Should pick only a 
  # certain job, and filter those records already imported successfully.
  def index
    @entities = {}
    @relation_types = {}
    Fact.all.each do |fact|
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

    @entities = @entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
