class DropCategoryFromCheatsheets < ActiveRecord::Migration
  def self.up
  	  remove_column :cheatsheets, :category
  	  add_column :cheatsheets, :counter, :integer
  end

  def self.down
  	  add_column :cheatsheets, :category, :string
  	  remove_column :cheatsheets, :counter
  end
end
