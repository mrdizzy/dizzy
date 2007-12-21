set :application, "dizzy"
set :repository,  "http://dizzy.googlecode.com/svn/trunk"
set :use_sudo, false
set :user, "dizzynew"   
set :password, "ruhegochelupraju"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :deploy_to, "/home/dizzynew/rails_apps/#{application}"
set :deploy_via, :export

set :rails_env, "production"
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "www21.a2hosting.com"
role :web, "www21.a2hosting.com"
role :db,  "www21.a2hosting.com", :primary => true

set :svn_username, "dizzynew_david"	
set :svn_password, "world1" 

# SSH OPTIONS
#=============================================================================
ssh_options[:port] = 7822 

	# DATABASE
# =============================================================================
set :database_adapter, "mysql"
set :database_username, "dizzynew"
set :database_password, "ruhegochelupraju"
set :database_hostname, "localhost"

# =============================================================================
desc "Tasks to execute after update"
task :after_update do
	
	# relink shared deployment database configuration
	run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
	
	# relink rails vendor
	# run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
	
	# chmod dispatchers and reaper
	run "chmod 755 #{release_path}/public/dispatch.fcgi"
	run "chmod 755 #{release_path}/public/dispatch.cgi"
	run "chmod 755 #{release_path}/script/process/reaper"
	run "chmod 755 #{release_path}/public"
end

# =============================================================================
# DATABASE.YML CREATION
# =============================================================================

desc "Construct database configuration"
desc "Setup Database Configuration"

	task :setup_database do

	 # generate database configuration
	 database_configuration =  <<-EOF
development:
  adapter: #{database_adapter}
  database: dizzynew_dizzydevelopment
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

# Warning: The database defined as 'test' will be erased and
# re-generated from your development database when you run 'rake'.
# Do not set this db to the same as development or production.
test:
  adapter: #{database_adapter}
  database: dizzynew_dizzytest
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

production:
  adapter: #{database_adapter}
  database: dizzynew_dizzyproduction
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}
EOF
	
	 # put database configuration in shared config dir
	 run "mkdir -p #{shared_path}/config" 
	 put database_configuration, "#{shared_path}/config/database.yml"
	
end
namespace :deploy do
	task :staging do
		default
		remigrate
		restart
	end
	
	task :remigrate do
		
	send(run_method, "cd #{deploy_to}/current && rake db:remigrate RAILS_ENV=production")
end
	task :start do
send(run_method, "cd #{deploy_to}/current && mongrel_rails cluster::start")
end

desc "Restart the mongrel cluster"
	task :restart, :roles => :app do
	send(run_method, "cd #{deploy_to}/current && mongrel_rails cluster::restart")
end
 namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your application's web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.

      By default, the maintenance page will just say the site is down for \
      "maintenance", and will be back "shortly", but you can customize the \
      page by specifying the REASON and UNTIL dcfsenvironment variables:

        $ cap deploy:web:disable \\
              BECAUSE="hardware upgrade" \\
              UNTIL="12pm Central Time"

      Further customization will require that you write your own task.
    DESC
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }
      reason = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(File.join(File.dirname(__FILE__), "maintenance.rhtml"))
      result = ERB.new(template).result(binding)

      put result, "#{shared_path}/system/maintenance.html", :mode => 0644
    end

    desc <<-DESC
      Makes the application web-accessible again. Removes the \
      "maintenance.html" page generated by deploy:web:disable, which (if your \
      web servers are configured correctly) will make your application \
      web-accessible again.
    DESC
    task :enable, :roles => :web, :except => { :no_release => true } do
      run "rm #{shared_path}/system/maintenance.html"
    end
  end
 end