class RemovePollsAndVotes < ActiveRecord::Migration
  def self.up
  	drop_table :polls
  	drop_table :votes
  end

  def self.down
  	
  create_table "polls", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
  end
  
  
  create_table "votes", :force => true do |t|
    t.integer "poll_id"
    t.string  "option"
    t.integer "total"
  end
  end
end
