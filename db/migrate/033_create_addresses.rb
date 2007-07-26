class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
    end
  end

  def self.down
    drop_table :addresses
  end
end
