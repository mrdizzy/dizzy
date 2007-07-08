class CreateConversations < ActiveRecord::Migration
  def self.up
    create_table :conversations do |t|
    	    t.column "subject",     :string
    t.column "status",      :string
    t.column "customer_id", :integer
    end
  end

  def self.down
    drop_table :conversations
  end
end
