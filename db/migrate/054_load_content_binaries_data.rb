class LoadContentBinariesData < ActiveRecord::Migration
  def self.up
  	down
  	directory = File.join(File.dirname(__FILE__), "data")
  	Fixtures.create_fixtures(directory, "content_binaries") 	
  end

  def self.down
  	ContentBinary.delete_all
  end
end
