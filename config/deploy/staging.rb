set :deploy_to, "/home/dizzynew/rails_apps/#{application}"

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

task :place_database_configuration do
  run "mkdir -p #{shared_path}/config" 
  put database_configuration, "#{shared_path}/config/database.yml"
end

# DEPLOYMENT
# =============================================================================

namespace :deploy do

	task :start do
 		run "cd #{deploy_to}/current && mongrel_rails start -p 12069 -e production -d"
	end

	desc "Restart mongrel"
	task :restart, :roles => :app do
		run "cd #{deploy_to}/current && mongrel_rails stop && mongrel_rails start -p 12069 -e production -d"
	end
end