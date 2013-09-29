require 'open-uri'

namespace :data do
  desc "Import list of facts into DB for later processing. Needs argument URI."
  task import: :environment do
    if ENV['URI'].nil? || ENV['job'].nil?
      puts "Missing arguments. Call the task as:"
      puts "    rake data:import job=myImporter URI=http://example.com/foobar.csv"
      puts "    rake data:import job=myImporter URI=foobar.csv"
    else
      # Import given data one record at a time
      @results = []
      open(ENV['URI']) do |file|
        CSV.open(file, headers: true).readlines.each do |row|
          next if row.size == 0  # Skip empty rows

          # FIXME: This below is almost a duplicate of the import controller.
          # The key difference (and it is a big one) is that fact properties are
          # updated if the source data has changed. This is dangerous, but it's just
          # what I need now to update CNMV data to include URLs. How to handle 
          # changing data is an important issue that needs to be examined carefully.

          # Check if the fact to be imported already exists.
          # We use the composite primary key source-role-target as a rough solution
          # for now, but there could be situations where this is not perfect: someone
          # has the same relation to the same org twice in her life for example. We may
          # need to add some deambiguation field at some point (maybe the date?), but
          # this will do for now.
          fact = Fact.where(importer: ENV['job'])
                      .where("properties->'Nombre' = ?", row['Nombre'])
                      .where("properties->'Cargo' = ?", row['Cargo'])
                      .where("properties->'Empresa' = ?", row['Empresa']).first
          if fact
            if ( fact.properties != row.to_hash )
              # Update the fact properties if it exists
              puts "Updating Fact #{fact.id}..."
              fact.properties = row.to_hash
              fact.save!
              @results << { fact: fact, imported: true }  # TODO: true-ish
            else  # Nothing to do
              @results << { fact: fact, imported: false }
            end
          else
            # We just import the whole thing into the database, hstore can handle it
            puts "Adding #{row.to_hash}..."
            fact = Fact.create!(importer: ENV['job'], properties: row.to_hash)
            @results << { fact: fact, imported: true }
          end
        end
      end

      puts "Loaded #{@results.size} records successfully."
    end
  end

end
