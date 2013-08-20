class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # FIXME: For now we'll just try importing all the data. Should pick only a 
  # certain job, and filter those records already imported successfully.
  # Something like this probably http://stackoverflow.com/questions/7032194/rails-habtm-and-finding-record-with-no-association?rq=1
  def index
    # Start by matching incoming data with the one already in the database
    @importer = CnmvImporter.new
    @results = @importer.match(Fact.all)

    # Return a sorted version of the results for convenience
    @entities = @importer.entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.relation_types.to_a.sort_by {|e| -e[1][:count]}

    # Do the actual import
    # FIXME: Do a dry run by default
    @importer.create_missing_objects
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
