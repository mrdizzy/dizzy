require 'active_record/fixtures'

class LoadCategoriesContentsData < ActiveRecord::Migration
  def self.up
  	down
  	 directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "categories_contents") 	
  end

  def self.down
  	execute "DELETE FROM categories_contents"
  end
end
