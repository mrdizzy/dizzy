set :deploy_to, "/home/dizzynew/rails_apps/staging/#{application}"

# DATABASE.YML CREATION
# =============================================================================
task :setup_database do

database_configuration = <<-EOF
	
common: &common
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

test:
  database: dizzynew_dizzytest
  <<: *common

production:
  database: dizzynew_dizzystaging
  <<: *common

EOF

end



# DEPLOYMENT
# =============================================================================

namespace :deploy do
	
	desc "start the app server"
	task :start, :roles => :app do
	send(run_method, "cd #{current_path} && mongrel_rails start -d -p 12182 -e #{rails_env}")
	end

end