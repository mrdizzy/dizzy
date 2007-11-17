# =============================================================================
# REQUIRED VARIABLES
# =============================================================================
set :home_root, "/users/home/dizzynewmedia" # Leading not trailing 
set :apps_dir, "/rails_apps" # Leading not trailing 
set :application, "dizzy"
set :domain, "http://dizzy.co.uk"
set :app_path, "#{home_root}#{apps_dir}/#{application}"
set :deploy_to, "#{app_path}"   
set :lighty_port, 8131 # The port given to you by TextDrive for running lighttpd
set :shared_rails_dir, "#{home_root}/rails"
set :keep_releases, 3
set :use_sudo, false
set :rails_env, :development
set :rails_version, "1-2-3"

	# LIGHTTPD CONFIG
set :lighttpd_config_path, "/etc/lighttpd"
set :lighttpd_config_script, "lighttpd.conf"

	# LIGHTTPD CONTROL
set :lighttpd_control_script, "lighttpd.sh"
set :lighttpd_control_path, "/etc/rc.d"

	# RAILS_CONTROL
set :rails_control_script, "rails.sh"
set :rails_control_path, "/etc/rc.d"
set :rails_version, "1.2.1"

	# SSH
set :ssh_domain, 'howe.textdrive.com' # The domain you ssh to for your server.
set :user, "dizzynewmedia"   
set :password, "JertEgg1"

	# SUBVERSION
set :scm, :subversion
# set :svn, '/path/to/bin/svn'
set :repository, "#{domain}/svn/#{application}" # SVN repo
set :checkout, "export"
set :svn_username, "david"	
set(:svn_password) { Capistrano::CLI.password_prompt }

	# DATABASE
set :database_adapter, "mysql"
set :database_username, "dizzynewmedia"
set :database_password, "JertEgg1"
	
# =============================================================================
# ROLES
# =============================================================================
role :web, ssh_domain, :primary => true
role :app, ssh_domain, :primary => true
role :db, ssh_domain, :primary => true

# =============================================================================
# INITIAL SETUP FOR COLD DEPLOY
# =============================================================================

desc "Make directories on TextDrive and setup lighttpd"
task :before_cold_deploy do  
  	write_lighty_config_file
  	write_lighttpdctrl_script
  	configure_vhosts
 	write_railsctrl_script
 	setup
 	setup_database
end

desc "Do initial setup and then get the new code for this site"
task :after_cold_deploy do   
	migrate
  # Start the lighty server
  run "#{home_root}#{lighttpd_control_path}/#{lighttpd_control_script} start" 
end

desc "Restart lighttpd"
task :restart_lighty do
	run "#{home_root}#{lighttpd_control_path}/#{lighttpd_control_script} restart" 
end

desc "Start the application"
task :spinner, :roles => :app do 
	 run "nohup #{home_root}#{rails_control_path}/#{rails_control_script}" 
end

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
# LIGHTTPD CONFIGURATION FILE
# =============================================================================
desc "Write customized lighttpd.conf file to server."
task :write_lighty_config_file do
   
  # Make some folders
  run "if [ ! -d var/run ]; then mkdir -p var/run; fi"
  run "if [ ! -d var/log ]; then mkdir var/log; fi"
  run "if [ ! -d etc/rc.d ]; then mkdir -p etc/rc.d; fi"
  run "if [ ! -d etc/lighttpd ]; then mkdir etc/lighttpd; fi"
  run "if [ ! -d etc/lighttpd/vhosts.d ]; then mkdir etc/lighttpd/vhosts.d; fi"
  run "if [ ! -d #{home_root}#{apps_dir} ]; then mkdir -p #{home_root}#{apps_dir}; fi"

  # Make the config file
  buffer = render(:template => <<LIGHTY_CONFIG)
server.dir-listing = "disable" 
server.modules              = ( "mod_rewrite",
                                "mod_redirect",
                                "mod_access",
                                "mod_cgi",
                                "mod_fastcgi",
                                "mod_accesslog",
                                "mod_alias" )

server.document-root        = "<%= app_path %>/current/public/" 

	# where to send error-messages to
server.errorlog             = "<%= home_root %>/var/log/lighttpd.error.log" 

	# files to check for if .../ is requested
server.indexfiles           = ( "index.html" )

	# mimetype mapping

include_shell "cat /usr/local/etc/lighttpd_mimetypes.conf"

	# Server ID Header
server.tag                 = "lighttpd | TextDriven" 

accesslog.filename          = "<%= home_root %>/var/log/access_log" 
url.access-deny             = ( "~", ".inc" )
server.port                =  <%= lighty_port %>
server.pid-file            = "<%= home_root %>/var/run/lighttpd.pid" 
server.username            = "<%= user %>" 
server.groupname           = "<%= user %>" 

include "vhosts.d/<%= application %>.conf"

LIGHTY_CONFIG

  # Write the config file to disk
  put buffer, "etc/lighttpd/lighttpd.conf" #, :mode => xxxx  
end

# =============================================================================
# VHOSTS CONFIGURATION FILE
# =============================================================================

desc "Sets up the vhosts file for lighttpd"
task :configure_vhosts do  
  buffer = render(:template => <<VHOSTSSCRIPT)

$HTTP["host"] =~ "main.dizzy.co.uk" {
  server.document-root        = "<%= app_path %>/current/public/"
  
  # Make static directory available
  alias.url = ( "/<%= application %>" => "<%= app_path %>/current/public" )
	server.error-handler-404 = "/dispatch.fcgi"
  fastcgi.server = ( ".fcgi" =>
        ( "localhost" =>
            ( "socket" => "<%= app_path %>/current/tmp/pids/<%= application %>-0.socket" )
    		)
  )
}

VHOSTSSCRIPT
 put buffer, "etc/lighttpd/vhosts.d/#{application}.conf"
end

# =============================================================================
# LIGHTTPD CONTROL SCRIPT
# =============================================================================

desc "Sets up lighttpd control script for starting, stopping, and restarting lighty"
task :write_lighttpdctrl_script do  
  buffer = render(:template => <<LIGHTTPDCTRL)
#!/bin/sh
# This is for Starting/Stopping/Restarting Lighttpd.

 HOME=/users/home/`whoami`
 LIGHTTPD_CONF=$HOME/etc/lighttpd/lighttpd.conf
 PIDFILE=$HOME/var/run/lighttpd.pid
 export SHELL=/bin/sh
 
case "$1" in
    start)
      # Starts the lighttpd deamon
      echo "Starting Lighttpd"
      PATH=$PATH:/usr/local/bin /usr/local/sbin/lighttpd -f $LIGHTTPD_CONF
  ;;

    stop)
      # stops the daemon bt cat'ing the pidfile                                                            
	    echo "Stopping Lighttpd"
      kill `/bin/cat $PIDFILE`
  ;;
    restart)
		  # Stop the service regardless of whether it was
		  # running or not, start it again.                                                                   
		  echo "Restarting Lighttpd"
      $0 stop
      $0 start
  ;;
    reload)
      # reloads the config file by sending HUP                                                             
		  echo "Reloading config"
      kill -HUP `/bin/cat $PIDFILE`
  ;;
  
    *)
      echo "Usage: lighttpdctrl (start|stop|restart|reload)"
      exit 1
  ;;
esac
LIGHTTPDCTRL
  
  put buffer, "etc/rc.d/lighttpd.sh", :mode => 0755
end

# =============================================================================
# RAILS CONTROL SCRIPT
# =============================================================================

desc "Sets up rails control script for stopping and starting apps"
task :write_railsctrl_script do  
  buffer = render(:template => <<LIGHTTPDCTRL)
#!/bin/sh
# This is for Starting/Stopping/Restarting Rails app.

export SHELL=/bin/sh

# This is for your main domain. Replace APPNAME with the appropriate value

RAILS_ENV=<%= rails_env %> /usr/local/bin/spawn-fcgi -f <%= app_path %>/current/public/dispatch.fcgi -s <%= app_path %>/current/tmp/pids/<%= application %>-0.socket -P <%= app_path %>/current/tmp/pids/dispatch.0.pid

LIGHTTPDCTRL
  
  put buffer, "etc/rc.d/rails.sh", :mode => 0755
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
  host: localhost
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