class CreateEmailsTickets < ActiveRecord::Migration
  def self.up
  	
  create_table "emails_tickets", :id => false, :force => true do |t|
    t.column "email_id", :integer
    t.column "ticket_id",  :integer
  end
  end

  def self.down
  	drop_table "emails_tickets"
  end
end
