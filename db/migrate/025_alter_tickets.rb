class AlterTickets < ActiveRecord::Migration
  def self.up
  	rename_column :tickets, :status, :type
  	change_column :tickets, :type, :string
  end

  def self.down
  	rename_column :tickets, :type, :status
  	change_column :tickets, :status, :boolean
  end
end
