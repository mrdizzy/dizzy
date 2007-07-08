class AlterCustomers < ActiveRecord::Migration
  def self.up
  	add_column :customers, :type, :string
  end

  def self.down
  	remove_column :customers, :type
  end
end
