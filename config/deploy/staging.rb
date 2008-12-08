set :deploy_to, "/home/dizzynew/rails_apps/staging/#{application}"

set :database_configuration, <<-EOF

production:
  database: dizzynew_dizzystaging
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

EOF

namespace :deploy do
	
	desc "start the app server"
	task :start, :roles => :app do
		send(run_method, "cd #{current_path} && mongrel_rails start -d -p 12182 -e #{rails_env}")
	end
	
	desc "import production database into staging"
	task :copy_production_database, :roles => :app do 
		send(run_method, "mysqldump -u #{database_username} --password=#{database_password} dizzynew_dizzyproduction > export.sql")
		send(run_method, "mysql -u #{database_username} --password=#{database_password} dizzynew_dizzystaging < export.sql")
	end
end

