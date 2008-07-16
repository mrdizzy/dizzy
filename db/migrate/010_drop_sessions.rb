class DropSessions < ActiveRecord::Migration
  def self.up
  	drop_table :sessions
  end

  def self.down
  	
  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  end
end
