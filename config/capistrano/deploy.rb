set :application, "dizzy"
set :repository,  "http://dizzy.googlecode.com/svn/trunk"
set :use_sudo, false
set :user, "dizzynew"   
set :password, "beaslewig175"

set :shared_rails_dir, "/home/dizzynew/rails_apps/rails_2_1_1"
set :deploy_to, "/home/dizzynew/rails_apps/#{application}"
set :deploy_via, :export

set :rails_env, "production"

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

# DATABASE.YML CREATION
# =============================================================================

desc "Construct database configuration"
desc "Setup Database Configuration"

task :setup_database do

database_configuration = <<-ENDOF

common: &common
  adapter: #{database_adapter}
  username: #{database_username}
  password: #{database_password}
  host: #{database_hostname}

test:
  database: dizzynew_dizzytest
  <<: *common

production:
  database: dizzynew_dizzyproduction
  <<: *common

ENDOF
	
end

task :staging_database do

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
	
	task :staging do
		set :deploy_to, "/home/dizzynew/rails_apps/staging/#{application}"
		default		
	end
	
	task :setup_staging do
		set :deploy_to, "/home/dizzynew/rails_apps/staging/#{application}"
		setup
	end
	
	task :setup_staging_database do 
		set :deploy_to, "/home/dizzynew/rails_apps/staging/#{application}"
		staging_database
	end
	
	task :remigrate do
		send(run_method, "cd #{deploy_to}/current && rake db:remigrate RAILS_ENV=production")
	end
	
	task :start do
 		run "cd #{deploy_to}/current && mongrel_rails start -p 12182 -e production -d"
	end

	desc "Restart the mongrel cluster"
	task :restart, :roles => :app do
		send(run_method, "cd #{deploy_to}/current && mongrel_rails restart")
	end
 
 	namespace :web do
    
    task :disable, :roles => :web, :except => { :no_release => true } do
      require 'erb'
      
      reason   = ENV['REASON']
      deadline = ENV['UNTIL']

      template = File.read(File.join(File.dirname(__FILE__), "maintenance.rhtml"))
      result   = ERB.new(template).result(binding)

      put result, "#{shared_path}/maintenance.html", :mode => 0644
      run "cd #{deploy_to}/current && mongrel_rails stop"
      run "cd #{deploy_to}/current && mongrel_rails start -S config/mongrel.conf -p 12182 -e production -r #{deploy_to}/shared -d"
    end
    
    task :enable, :roles => :web, :except => { :no_release => true } do
    	run "cd #{deploy_to}/current && mongrel_rails stop"
      run "cd #{deploy_to}/current && mongrel_rails start -p 3012 -e production -d"
    end
  end
 end