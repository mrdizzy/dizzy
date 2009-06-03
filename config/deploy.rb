set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, "intentional-stance.com"
set :repository,  "https://dizzy.googlecode.com/svn/trunk"
set :use_sudo, false
set :user, "dizzyphoenix"   
set :password, "world1"

set :shared_rails_dir, "/home/dizzynew/rails_apps/rails_2_1_1"
set :deploy_via, :export

set :rails_env, "production"

server "thing.dreamhost.com", :app, :web, :db, :primary => true

set :svn_username, "david.pettifer"		
	
#ssh_options[:port] = 7822 

set :database_adapter, "mysql"
set :database_username, "denzil"
set :database_password, "fantasyland"
set :database_hostname, "mysql.dizzyphoenix.dreamhosters.com"

# =============================================================================

desc "Tasks to execute after update"
task :after_update do
	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
end

namespace :deploy do
	desc "Restart the app server"
		task :restart, :roles => :app do
		run "cd #{current_path}/tmp && touch restart.txt"
	end
end

desc "Create database.yml file"
task :setup_database do
	
	run "mkdir -p #{shared_path}/config" 
		 database_configuration =  <<-EOF
development:
  adapter: #{database_adapter}
  database: dizzyphoenix_dizzydevelopment
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

# Warning: The database defined as 'test' will be erased and
# re-generated from your development database when you run 'rake'.
# Do not set this db to the same as development or production.
test:
  adapter: #{database_adapter}
  database: dizzyphoenix_dizzytest
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

production:
  adapter: #{database_adapter}
  database: dizzyphoenix_dizzyproduction
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}
EOF
	put database_configuration, "#{shared_path}/config/database.yml"
	
end