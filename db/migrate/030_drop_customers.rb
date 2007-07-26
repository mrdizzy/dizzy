class DropCustomers < ActiveRecord::Migration
  def self.up
  	drop_table :customers
  end

  def self.down
  	
  create_table "customers", :force => true do |t|
    t.column "firstname", :string
    t.column "surname",   :string
    t.column "type",      :string
  end
  end
end
