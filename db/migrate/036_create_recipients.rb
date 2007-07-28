class CreateRecipients < ActiveRecord::Migration
  def self.up
    create_table :recipients do |t|
    	t.column :email_id, :integer
    	t.column :ticket_id, :integer
    	t.column :type, :string
    	
    end
  end

  def self.down
    drop_table :recipients
  end
end
