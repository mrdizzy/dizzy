class AddImageColumns < ActiveRecord::Migration
  def self.up
  add_column :portfolio_items, :content_type, :string
  add_column :portfolio_items, :filename, :string
  add_column :portfolio_items, :size, :integer

  end

  def self.down

  remove_column :portfolio_items, :content_type
  remove_column :portfolio_items, :filename
  remove_column :portfolio_items, :size
  
  end
end
