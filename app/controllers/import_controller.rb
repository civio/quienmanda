class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # TODO: For now we'll just try importing all the data. Should pick only a 
  # certain job, and filter those records already imported successfully.
  def index
    @found_entities = {}
    @missing_entities = {}
    @found_relation_types = {}
    @missing_relation_types = {}
    Fact.all.each do |fact|
      # Try to find an existing RelationType matching the imported data
      role = fact.properties['Cargo']
      relation_type = RelationType.find_by(["lower(description) = ?", role.downcase])

      # Keep track of success/failures
      end_bucket = (relation_type) ? @found_relation_types : @missing_relation_types
      end_bucket[role] = (end_bucket[role] || 0) + 1


      # Try to find an existing Entity matching the imported data
      source = fact.properties['Nombre']
      source_entity = Entity.find_by(["lower(name) = ?", source.downcase])

      # Keep track of success/failures
      end_bucket = (source_entity) ? @found_entities : @missing_entities
      end_bucket[source] = (end_bucket[source] || 0) + 1


      # Try to find an existing Entity matching the imported data
      target = fact.properties['Empresa']
      target_entity = Entity.find_by(["lower(name) = ?", target.downcase])

      # Keep track of success/failures
      end_bucket = (target_entity) ? @found_entities : @missing_entities
      end_bucket[target] = (end_bucket[target] || 0) + 1
    end

    @found_entities = @found_entities.to_a.sort_by {|e| -e[1]}
    @missing_entities = @missing_entities.to_a.sort_by {|e| -e[1]}
    @found_relation_types = @found_relation_types.to_a.sort_by {|e| -e[1]}
    @missing_relation_types = @missing_relation_types.to_a.sort_by {|e| -e[1]}
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
