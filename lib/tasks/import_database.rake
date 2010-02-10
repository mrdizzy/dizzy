namespace :db do
  desc 'Imports a raw SQL file into the database'
  task :import_raw_sql => :load_config do
  	ActiveRecord::Base.establish_connection
    puts `mysql -u root #{ActiveRecord::Base.configurations[RAILS_ENV]['database']} <export.sql`
	end
end