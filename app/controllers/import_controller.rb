require 'charlock_holmes'

class ImportController < ApplicationController
  layout "admin"

  before_filter :check_admin

  # Show static page with import-related actions
  def index
  end

  # Handle upload of a new CSV file
  def upload
    # We can't rely on the file encoding being correct, so find out which one we got...
    content = File.read(params[:file].path)
    detection = CharlockHolmes::EncodingDetector.detect(content)
    utf8_encoded_content = CharlockHolmes::Converter.convert content, detection[:encoding], 'UTF-8'

    # Parse the uploaded content, once converted to UTF8
    @results = []
    CSV.parse(utf8_encoded_content, headers: true) do |row|
      next if row.size == 0  # Skip empty lines

      # Check if the fact to be imported already exists.
      # We use the composite primary key source-role-target as a rough solution
      # for now, but there could be situations where this is not perfect: someone
      # has the same relation to the same org twice in her life for example. We may
      # need to add some deambiguation field at some point (maybe the date?), but
      # this will do for now.
      fact = Fact.where(importer: 'CSV')
                  .where("properties->'source' = ?", row['source'])
                  .where("properties->'role' = ?", row['role'])
                  .where("properties->'target' = ?", row['target']).first
      if fact
        # Do nothing for now, we have the fact already
        @results << { fact: fact, imported: false }
      else
        # We just import the whole thing into the database, hstore can handle it
        fact = Fact.create!(importer: 'CSV', properties: row.to_hash)
        @results << { fact: fact, imported: true }
      end
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
    @results = @importer.match( @facts.limit(params[:import_size]||150), 
                                dry_run: @dry_run, 
                                matching_threshold: 0.6)

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
