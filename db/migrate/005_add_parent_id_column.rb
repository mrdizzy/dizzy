class AddParentIdColumn < ActiveRecord::Migration
  def self.up
  	add_column :portfolio_items, :parent_id, :integer
  	add_column :portfolio_items, :db_file_id, :integer
    # only for db-based files
     create_table :db_files, :force => true do |t|
          t.column :data, :binary
     end  	
  end

  def self.down
  	remove_column :portfolio_items, :parent_id
  	remove_column :portfolio_items, :db_file_id
  	drop_table :db_files
  end
end
