# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :home_root, "/home/dizzynewmedia" # Leading not trailing 
set :apps_dir, "/rails_apps" # Leading not trailing 
set :application, "dizzy"
set :domain, "http://dizzy.co.uk"
set :app_path, "#{home_root}#{apps_dir}/#{application}"
set :deploy_to, "#{app_path}"   
#set :lighty_port, 8131 # The port given to you by TextDrive for running lighttpd
set :shared_rails_dir, "#{home_root}/rails"
set :keep_releases, 3
set :use_sudo, false
set :rails_env, :development
set :rails_version, "1-2-3"

	# LIGHTTPD CONFIG
#set :lighttpd_config_path, "/etc/lighttpd"
#set :lighttpd_config_script, "lighttpd.conf"

	# LIGHTTPD CONTROL
#set :lighttpd_control_script, "lighttpd.sh"
#set :lighttpd_control_path, "/etc/rc.d"

	# RAILS_CONTROL
#set :rails_control_script, "rails.sh"
#set :rails_control_path, "/etc/rc.d"
#set :rails_version, "1.2.1"

	# SSH
set :ssh_domain, 'thunderbird.dreamhost.com' # The domain you ssh to for your server.
set :user, "dizzynewmedia"   
set :password, "Tipih9jq"

	# SUBVERSION
set :scm, :subversion
# set :svn, '/path/to/bin/svn'
set :repository, "https://dizzy.googlecode.com/svn/trunk" # SVN repo
set :checkout, "export"
set :svn_username, "david.pettifer"	
set(:svn_password) { "j6y3h5d4" }

	# DATABASE
set :database_adapter, "mysql"
set :database_username, "dizzynewmedia"
set :database_password, "Tipih9jq"
set :database_host, "mysql.dizzynewmedia.dreamhosters.com"
	
# =============================================================================
# ROLES
# =============================================================================
role :web, ssh_domain, :primary => true
role :app, ssh_domain, :primary => true
role :db, ssh_domain, :primary => true

# =============================================================================
# TASKS TO EXECUTE AFTER CODE UPDATE
# =============================================================================

desc "Tasks to execute after update"
task :after_update do
	
	# relink shared deployment database configuration
	run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml"
	# relink rails vendor
	run "ln -nfs #{shared_rails_dir} #{release_path}/vendor/rails "
	# chmod dispatch.fcgi and reaper
	run "chmod 755 #{release_path}/public/dispatch.fcgi"
	run "chmod 755 #{release_path}/script/process/reaper"
end

# =============================================================================
# DATABASE.YML CREATION
# =============================================================================

desc "Construct database configuration"
desc "Setup Database Configuration"
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
 run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
 put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml"
end

# =============================================================================
# DEPLOY SHARED RAILS VERSION
# =============================================================================
desc "Deploy a shared Rails version"
task :deploy_rails do
  ENV['RAILS_TAG'] ||= "rel_#{rails_version}"
  checkout_path = "#{shared_rails_dir}"
  symlink_path  = "#{release_path}/vendor/rails"

  run <<-CMD
    if [ ! -d #{checkout_path} ];
    then
     echo "Checking out Rails #{ENV['RAILS_TAG']}...";
     svn checkout --quiet http://dev.rubyonrails.org/svn/rails/tags/#{ENV['RAILS_TAG']} \     
                          #{checkout_path};
    fi
  CMD
  
  puts 'Linking Rails...'
  run "rm -rf #{symlink_path}"
  run "ln -nfs #{checkout_path} #{symlink_path}"
end