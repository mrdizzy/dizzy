class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
		t.column "email",       :string
    	t.column "customer_id", :integer
    end
  end

  def self.down
    drop_table :emails
  end
end
