class CreatePolls < ActiveRecord::Migration
  def self.up
    create_table :polls do |t|
    	t.column :name, :string
    	t.column :created_at, :datetime
    end
  end

  def self.down
    drop_table :polls
  end
end
