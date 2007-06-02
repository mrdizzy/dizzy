class RemoveActsAsAttachment < ActiveRecord::Migration
  def self.up
  			drop_table :db_files
  		  remove_column :portfolio_items, :db_file_id
  		  remove_column :portfolio_items, :parent_id
  		  add_column :portfolio_items, :data, :binary
  end

  def self.down
  		create_table :db_files, :force => true do |t|
          t.column :data, :binary
      end
  		add_column :portfolio_items, :parent_id, :integer
  		add_column :portfolio_items, :db_file_id, :integer
  		remove_column :portfolio_items, :data
end
end
