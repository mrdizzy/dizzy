class AddPermalinkToCheatsheet < ActiveRecord::Migration
  def self.up
 	add_column :cheatsheets, :permalink, :string
  end

  def self.down
  	remove_column :cheatsheets, :permalink
  end
end
