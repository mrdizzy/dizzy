class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
    	t.column :firstname, :string
    	t.column :surname, :string
    end
  end

  def self.down
    drop_table :customers
  end
end
