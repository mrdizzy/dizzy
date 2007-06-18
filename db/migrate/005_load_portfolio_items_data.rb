require 'active_record/fixtures'

class LoadPortfolioItemsData < ActiveRecord::Migration
  def self.up
  
  down
  
  directory = File.join(File.dirname(__FILE__), "data")
  Fixtures.create_fixtures(directory, "portfolio_items")
    
  end

  def self.down
  	PortfolioItem.delete_all
  end
end
