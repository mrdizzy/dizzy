# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'
RAILS_GEM_VERSION = '2.1.1'

# Recaptcha keys
RECAPTCHA_PUBLIC_KEY = '6LfP1AQAAAAAAAKhfOUrKLj87PfBp77czQ87drhk'
RECAPTCHA_PRIVATE_KEY = '6LfP1AQAAAAAAJLC4g8ticB9p5RuyEdq1QH4syc6'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_web_service ]
config.active_record.schema_format = :sql
  config.time_zone = 'London'
  
  # Add load paths for sweepers and mailers
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  config.load_paths << "#{RAILS_ROOT}/app/mailers"
  
  config.action_controller.session = { :session_key => "_dizzy_session", :secret => "beaslewig175world66607814752865" }
  
  config.gem "maruku" 
  config.gem "coderay"
  config.gem "thoughtbot-factory_girl",
             :lib    => "factory_girl",
             :source => "http://gems.github.com"
end

# Include your application configuration below
#ActionController::AbstractRequest.relative_url_root = "/dizzy" 

load "#{RAILS_ROOT}/lib/maruku_patch.rb"