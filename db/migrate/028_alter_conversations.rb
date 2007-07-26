class AlterConversations < ActiveRecord::Migration
  def self.up
  	rename_column :conversations, :customer_id, :person_id
  end

  def self.down
  	rename_column :conversations, :person_id, :customer_id
  end
end
