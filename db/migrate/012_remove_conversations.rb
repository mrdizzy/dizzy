class RemoveConversations < ActiveRecord::Migration
  def self.up
  	drop_table :conversations
  end

  def self.down
  	
  create_table "conversations", :force => true do |t|
    t.string   "subject"
    t.string   "name"
    t.datetime "created_at"
    t.string   "email"
    t.text     "body"
  end
  end
end
