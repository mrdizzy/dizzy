set :deploy_to, "/home/dizzyphoenix/#{application}"

set :database_configuration, <<-EOF

production:
  database: dizzynew_dizzyproduction
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

EOF

namespace :deploy do
	
	desc "Dump and download the production database"
		task :download_database, :roles => :app do 
		run("mysqldump -u #{database_username} --password=beaslewig175 dizzynew_dizzyproduction >export.sql")
		download "export.sql", "export.sql"
	end

end