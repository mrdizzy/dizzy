require 'active_record/fixtures'

class LoadCategoriesData < ActiveRecord::Migration
  def self.up
  
  down
  
  directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "categories")
    
  end

  def self.down
  	Category.delete_all
  end
end
