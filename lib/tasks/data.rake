require 'open-uri'

namespace :data do
  desc "Import list of facts into DB for later processing. Needs argument URI."
  task import: :environment do
    if ENV['URI'].nil? || ENV['job'].nil?
      puts "Missing arguments. Call the task as:"
      puts "    rake data:import job=myImporter URI=http://example.com/foobar.csv"
      puts "    rake data:import job=myImporter URI=foobar.csv"
    else
      # TODO: For now we just do a full-refresh of the data on each load. Brute.      
      Fact.delete_all(importer: ENV['job'])

      # Import given data one record at a time
      count = 0
      open(ENV['URI']) do |file|
        CSV.open(file, headers: true).readlines.each do |line|
            next if line.size == 0  # Skip empty lines

            # We just import the whole thing into the database, hstore can handle it
            Fact.create(importer: ENV['job'], properties: line.to_hash)
            count += 1
        end
      end

      puts "Loaded #{count} records successfully."
    end
  end

end
