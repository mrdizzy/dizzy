set :default_stage, 'staging'
require 'capistrano/ext/multistage'

set :application, "dizzy"
set :repository,  "http://dizzy.googlecode.com/svn/trunk"
set :use_sudo, false
set :user, "dizzynew"   
set :password, "beaslewig175"

set :shared_rails_dir, "/home/dizzynew/rails_apps/rails_2_1_1"
set :deploy_via, :export

set :rails_env, "production"

server "www21.a2hosting.com", :app, :web, :db, :primary => true

set :svn_username, "david.pettifer"		
	
ssh_options[:port] = 7822 

set :database_adapter, "mysql"
set :database_username, "dizzynew"
set :database_password, "beaslewig175"
set :database_hostname, "127.0.0.1"

# =============================================================================

desc "Tasks to execute after update"
task :after_update do
	
	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
	
end

desc "Create database.yml file"
task :setup_database do
	
	run "mkdir -p #{shared_path}/config" 
	put database_configuration, "#{shared_path}/config/database.yml"
	
end

namespace :deploy do
	
	desc "Stop the app server"
	task :stop, :roles => :app do
		
		send(run_method, "cd #{current_path} && mongrel_rails stop")
		
	end

	desc "Restart the app server"
	task :restart, :roles => :app do
		
		send(run_method, "cd #{current_path} && mongrel_rails restart")
		
	end
	
end