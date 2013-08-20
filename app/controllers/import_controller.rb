class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  def index
    # Matching the incoming data with the one already in the database,
    # and create the missing entities/relations
    @importer = CnmvImporter.new(create_missing_entities: true)
    # Limit number of facts to import to avoid timeouts in Heroku
    facts = Fact.unprocessed_facts.limit(params[:import_size]||300)
    @results = @importer.match(facts, dry_run: true)

    # Return a sorted version of the results for convenience
    @entities = @importer.matched_entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.matched_relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
