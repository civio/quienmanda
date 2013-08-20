class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # Matching the incoming data with the one already in the database,
  # and create the missing entities/relations
  def import(dry_run: true)
    @importer = CnmvImporter.new(create_missing_entities: true)
    # Limit number of facts to import to avoid timeouts in Heroku
    facts = Fact.unprocessed_facts.limit(params[:import_size]||300)
    @dry_run = dry_run
    @results = @importer.match(facts, dry_run: @dry_run)

    # Return a sorted version of the results for convenience
    @entities = @importer.matched_entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.matched_relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  def commit
    # TODO: I should check here that we're not posting the same form twice.
    #       Add f.ex. an argument with the first fact ID, and check it fits with the DB
    import(dry_run: false)
    render :import
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
