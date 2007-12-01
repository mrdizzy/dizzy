require 'active_record/fixtures'

class LoadContentsData < ActiveRecord::Migration
  def self.up
 
  down
  
  directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "contents") 	
  end

  def self.down
  	Content.delete_all
  end
end
