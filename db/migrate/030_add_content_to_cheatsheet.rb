class AddContentToCheatsheet < ActiveRecord::Migration
  def self.up
  	add_column :cheatsheets, :content, :text
  end

  def self.down
  	remove_column :cheatsheets, :content
  end
end
