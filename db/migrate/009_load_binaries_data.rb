class LoadBinariesData < ActiveRecord::Migration
  def self.up
  	down
  	directory = File.join(File.dirname(__FILE__), "data")
  	Fixtures.create_fixtures(directory, "binaries") 	
  end

  def self.down
  	Binary.delete_all
  end
end
