set :deploy_to, "/home/dizzynew/rails_apps/#{application}"

set :database_configuration, <<-EOF

production:
  database: dizzynew_dizzyproduction
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

EOF

namespace :deploy do
	
	desc "start the app server"
	task :start, :roles => :app do
	send(run_method, "cd #{current_path} && mongrel_rails start -d -p 12089 -e #{rails_env}")
	end

end