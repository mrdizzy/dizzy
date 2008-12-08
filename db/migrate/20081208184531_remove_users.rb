class RemoveUsers < ActiveRecord::Migration
  def self.up
  	remove_column :contents, :user_id
  	drop_table :users
  end

  def self.down
  end
end
