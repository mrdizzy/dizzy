require 'capistrano/ext/multistage'

set :default_stage, 'staging'

# Git
set :repository,  "git@github.com:mrdizzy/dizzy.git"
set :scm, "git"
set :scm_verbose, true
set :git_enable_submodules, 1
set :deploy_via, :remote_cache
set :branch, "master"
set :deploy_via, :export

# Application
set :application, "staging.dizzy.co.uk"
set :shared_rails_dir, "/home/dizzynew/rails_apps/rails_2_1_1"
set :rails_env, "production"

# SSH
server "supergirl.dreamhost.com", :app, :web, :db, :primary => true
set :use_sudo, false
set :user, "dizzyphoenix"   
set :password, "world1"
ssh_options[:forward_agent] = true    
#ssh_options[:port] = 7822 

# Database
set :database_adapter, "mysql"
set :database_username, "denzil"
set :database_password, "fantasyland"
set :database_hostname, "mysql.dizzyphoenix.dreamhosters.com"

set :database_configuration,  <<-EOF

test:
  adapter: #{database_adapter}
  database: dizzy_test
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

production:
  adapter: #{database_adapter}
  database: dizzy_production
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}
EOF

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
	put database_configuration, "#{shared_path}/config/database.yml"
end