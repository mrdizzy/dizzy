class CreateTicketCollaterals < ActiveRecord::Migration
  def self.up
    create_table :ticket_collaterals do |t|
	    t.column "name",         :string
	    t.column "body",         :binary
	    t.column "ticket_id",    :integer
	    t.column "content_type", :string    	
    end
  end

  def self.down
    drop_table :ticket_collaterals
  end
end
