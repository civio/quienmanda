class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # FIXME: For now we'll just try importing all the data. Should pick only a 
  # certain job, and filter those records already imported successfully.
  # Something like this probably http://stackoverflow.com/questions/7032194/rails-habtm-and-finding-record-with-no-association?rq=1
  def index
    # Matching the incoming data with the one already in the database,
    # and create the missing entities/relations
    @importer = CnmvImporter.new(create_missing_entities: true)
    @results = @importer.match(Fact.all, dry_run: true)

    # Return a sorted version of the results for convenience
    @entities = @importer.matched_entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.matched_relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
