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
	
# SSH OPTIONS
#=============================================================================
ssh_options[:port] = 7822 

# DATABASE
# =============================================================================
set :database_adapter, "mysql"
set :database_username, "dizzynew"
set :database_password, "beaslewig175"
set :database_hostname, "localhost"

# =============================================================================
desc "Tasks to execute after update"
task :after_update do
	
	# relink shared deployment database configuration
	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	
	# relink rails vendor
	 run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
	
end