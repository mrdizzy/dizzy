class AlterCategoriesContents < ActiveRecord::Migration
  def self.up
  	add_column :categories_contents, :main, :boolean
  end

  def self.down
  	remove_column :categories_contents, :main
  end
end
