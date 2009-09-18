class AlterPortfolioItems < ActiveRecord::Migration
  def self.up
    rename_column :portfolio_items, :data, :image_binary_data
    add_column :portfolio_items, :image_filename, :string
    add_column :portfolio_items, :image_content_type, :string
    remove_column :portfolio_items, :size
  end

  def self.down
    rename_column :portfolio_items, :image_binary_data, :data
    remove_column :portfolio_items, :image_filename
    remove_column :portfolio_items, :image_content_type
  end
end
