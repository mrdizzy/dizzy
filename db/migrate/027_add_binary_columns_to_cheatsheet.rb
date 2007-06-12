class AddBinaryColumnsToCheatsheet < ActiveRecord::Migration
  def self.up
  	add_column :cheatsheets, :filename, :string
  	add_column :cheatsheets, :content_type, :string
  	add_column :cheatsheets, :size, :integer
  end

  def self.down
  	  	remove_column :cheatsheets, :filename
  	remove_column :cheatsheets, :content_type
  	remove_column :cheatsheets, :size
  end
end
