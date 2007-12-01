namespace(:db) do
  require File.join(File.dirname(__FILE__), 'helpers')

  FIXTURE_DIRECTORY = path('test', 'fixtures', RAILS_ENV)

  namespace(:fixtures) do
    desc("Create YAML test fixtures from the data in the current environment's database.")
    task(:generate => :environment) do
      ActiveRecord::Base.establish_connection

      # Create the fixtures directory if it doesn't exist.
      Dir.mkdir(FIXTURE_DIRECTORY) unless File.exist?(FIXTURE_DIRECTORY)
      # Delete any existing fixture files.
      system("rm #{File.join(FIXTURE_DIRECTORY, '*.yml')}")

      # Dump each table in the database to a separate YAML fixtures file.
      tables.each do |table_name|
        puts(table_name)
        File.open(File.join(FIXTURE_DIRECTORY, "#{table_name}.yml"), 'w') do |file|
          i = "00000"
          # Convert each row retrieved from the query into YAML.
          file.write ActiveRecord::Base.connection.select_all("SELECT * FROM #{table_name}").inject({}) { |hash, row|
            hash["#{table_name}_#{i.succ!}"] = row
            hash
          }.to_yaml
        end
      end
    end
  end
end