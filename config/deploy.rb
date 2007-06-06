set :application, "dizzy"
set :repository,  "http://dizzy.googlecode.com/svn/trunk"
set :use_sudo, false
set :user, "dizzynewmedia"   
set :password, "Tipih9jq"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :deploy_to, "/home/dizzynewmedia/rails_apps/#{application}"
set :deploy_via, :export

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "thunderbird.dreamhost.com"
role :web, "thunderbird.dreamhost.com"
role :db,  "thunderbird.dreamhost.com", :primary => true

set :svn_username, "david.pettifer"	
set :svn_password, "j6y3h5d4" 

	# DATABASE
# =============================================================================
set :database_adapter, "mysql"
set :database_username, "dizzynewmedia"
set :database_password, "Tipih9jq"
set :database_host, "mysql.dizzynewmedia.dreamhosters.com"

# =============================================================================
desc "Tasks to execute after update"
task :after_update do
	
	# relink shared deployment database configuration
	run "ln -nfs #{deploy_to}/#{shared_path}/config/database.yml #{release_path}/config/database.yml"
	# relink rails vendor
	# run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
	# chmod dispatch.fcgi and reaper
	run "chmod 755 #{release_path}/public/dispatch.fcgi"
	run "chmod 755 #{release_path}/script/process/reaper"
end

# =============================================================================
# DATABASE.YML CREATION
# =============================================================================

desc "Construct database configuration"
desc "Setup Database Configuration"
namespace :deploy do
	task :setup_database do

	 # generate database configuration
	 database_configuration = render :template => <<-EOF
	# Deployment database.yml
	login: &login
	  adapter: #{database_adapter}
	  host: #{database_host}
	  username: #{database_username}
	  password: #{database_password}
	
	development:
	 database: #{application}_development
	 <<: *login
	
	test:
	 database: #{application}_test
	 <<: *login
	
	production:
	 database: #{application}_production
	 <<: *login
	
	EOF
	
	 # put database configuration in shared config dir
	 run "mkdir -p #{deploy_to}/#{shared_path}/config" 
	 put database_configuration, "#{deploy_to}/#{shared_path}/config/database.yml"
	end
end
