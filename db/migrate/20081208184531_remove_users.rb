class RemoveUsers < ActiveRecord::Migration
  def self.up
  	execute "ALTER TABLE contents DROP FOREIGN KEY fk_user_contents;"
  	remove_column :contents, :user_id
  	drop_table :users
  end

  def self.down
  end
end
