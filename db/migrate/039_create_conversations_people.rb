class CreateConversationsPeople < ActiveRecord::Migration
  def self.up
  	create_table "conversations_people", :id => false, :force => true do |t|
   	 	t.column "conversation_id", :integer
    	t.column "person_id",  :integer
  	end
  end

  def self.down
  	drop_table :conversations_people
  end
end
