ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase

  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
  	 
  def savefile(input)
    aFile = File.new("file.html", "w")
    aFile.write(input)
    aFile.close
  end
   
  def login
  	 post "/administrator_sessions", :admin_password => PASSWORD
  end
  
  def admin_pass
    { :admin_password => PASSWORD }
  end

end
