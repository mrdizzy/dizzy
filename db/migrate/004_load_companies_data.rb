require 'active_record/fixtures'

class LoadCompaniesData < ActiveRecord::Migration
  def self.up
  
  down
  
  directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "companies")
    
  end

  def self.down
  	Company.delete_all
  end
end
