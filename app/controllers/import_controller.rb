class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # TODO: For now we'll just try importing all the data. Should pick only a 
  # certain job, and filter those records already imported successfully.
  def index
    @importer = Importer.new(source_name: 'Nombre', role_name: 'Cargo', target_name: 'Empresa')
    Fact.all.each {|fact| @importer.match(fact) }

    # Return a sorted version of the results for convenience
    @entities = @importer.entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
