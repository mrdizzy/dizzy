class RemovePersonIdFromConversations < ActiveRecord::Migration
  def self.up
  	remove_column :conversations, :person_id
  end

  def self.down
  	add_column :conversations, :person_id, :integer
  end
end
