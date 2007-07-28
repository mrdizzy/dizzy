class AlterEmailsTickets < ActiveRecord::Migration
  def self.up
  	add_column :emails_tickets, :type, :string
  end

  def self.down
  	remove_column :emails_tickets, :type
  end
end
