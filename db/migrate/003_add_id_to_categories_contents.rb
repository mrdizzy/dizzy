class AddIdToCategoriesContents < ActiveRecord::Migration
  def self.up
  	add_column :categories_contents, :id, :integer
  end

  def self.down
  	remove_column :categories_contents, :id
  end
end
