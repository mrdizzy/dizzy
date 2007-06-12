class CategoriesCheatsheets < ActiveRecord::Migration
  def self.up
  	create_table :categories_cheatsheets, :id => false do |t| 
      # t.column :name, :string
      t.column :category_id, :integer
      t.column :cheatsheet_id, :integer
	end
  end

  def self.down
  	drop_table :categories_cheatsheets  	
  end
end
