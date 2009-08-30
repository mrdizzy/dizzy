set :deploy_to, "/home/dizzyphoenix/staging.dizzy.co.uk"

set :database_configuration, <<-EOF

production:
  database: dizzy_staging
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

EOF

namespace :deploy do
	
	desc "import production database into staging"
	task :copy_production_database, :roles => :app do 
		send(run_method, "mysqldump dizzy_production --no-create-db -u #{database_username} --password=#{database_password} -h mysql.dizzyphoenix.dreamhosters.com > export.sql")
		send(run_method, "mysql -u #{database_username} --password=#{database_password} -h mysql.dizzyphoenix.dreamhosters.com dizzy_staging < export.sql")
	end
end

