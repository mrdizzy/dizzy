class AddNotNullConstraints < ActiveRecord::Migration
  def self.up
	change_column :comments, :content_id, :integer, :null => false
	change_column :portfolio_items, :portfolio_type_id, :integer, :null => false
	change_column :portfolio_items, :company_id, :integer, :null => false
	change_column :binaries, :content_id, :integer, :null => false
	change_column :sections, :content_id, :integer, :null => false
	change_column :categories_contents, :content_id, :integer, :null => false
	change_column :categories_contents, :category_id, :integer, :null => false
	change_column :contents_contents, :content_id, :integer, :null => false
	change_column :contents_contents, :related_id, :integer, :null => false
  end

  def self.down
  end
end
