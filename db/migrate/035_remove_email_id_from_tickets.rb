class RemoveEmailIdFromTickets < ActiveRecord::Migration
  def self.up
  	remove_column :tickets, :email_id
  end

  def self.down
  	add_column :tickets, :email_id, :integer
  end
end
