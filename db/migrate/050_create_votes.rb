class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
    	t.column :poll_id, :integer
    	t.column :option, :string
    	t.column :total, :integer
    end
  end

  def self.down
    drop_table :votes
  end
end
