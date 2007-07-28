class DropEmailsTickets < ActiveRecord::Migration
  def self.up
  	drop_table :emails_tickets
  end

  def self.down
  	  create_table "emails_tickets", :id => false, :force => true do |t|
    t.column "email_id",  :integer
    t.column "ticket_id", :integer
    t.column "type",      :string
  end
  end
end
