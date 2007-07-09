class AlterConversation < ActiveRecord::Migration
  def self.up
  	  rename_column :conversations, :status, :type
  	
  end

  def self.down
  	rename_column :tickets, :type, :status
  	
  end
end
