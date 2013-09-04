class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # Show static page with import-related actions
  def index
  end

  # Handle upload of a new CSV file
  def upload
    @results = []
    @count = 0
    CSV.foreach(params[:file].path, headers: true) do |row|
      next if row.size == 0  # Skip empty lines

      # We just import the whole thing into the database, hstore can handle it
      # FIXME: This is very bad, it will duplicate facts on each import!
      fact = Fact.create(importer: 'CSV', properties: row.to_hash)
      @count += 1

      @results << "Uploaded Fact #{fact}"
    end
  end

  # Matching the incoming data with the one already in the database,
  # and create the missing entities/relations
  def process_facts(dry_run: true)
    # Not the most elegant solution, should use reflection probably, but will do for now...
    if params[:importer] == 'CNMV'
      @importer = CnmvImporter.new(create_missing_entities: true)
      @facts = Fact.unprocessed_facts.importer('CNMV')
    else
      @importer = CsvImporter.new(create_missing_entities: true)
      @facts = Fact.unprocessed_facts.importer('CSV')
    end
    @dry_run = dry_run
    # Limit number of facts to import to avoid timeouts in Heroku
    @results = @importer.match(@facts.limit(params[:import_size]||300), dry_run: @dry_run)

    # Return a sorted version of the results for convenience
    @entities = @importer.matched_entities.to_a.sort_by {|e| -e[1][:count]}
    @relation_types = @importer.matched_relation_types.to_a.sort_by {|e| -e[1][:count]}
  end

  def commit
    # TODO: I should check here that we're not posting the same form twice.
    #       Add f.ex. an argument with the first fact ID, and check it fits with the DB
    process_facts(dry_run: false)
    render :process_facts
  end

  private
    def check_admin
      redirect_to root_url unless current_user.try(:admin?)
    end
end
