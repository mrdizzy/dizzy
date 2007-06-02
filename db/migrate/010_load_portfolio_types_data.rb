require 'active_record/fixtures'

class LoadPortfolioTypesData < ActiveRecord::Migration
  def self.up
  	
  down
  
  directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "portfolio_types")
  
  end

  def self.down
  	PortfolioType.delete_all
  end
end
