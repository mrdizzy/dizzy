class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
	t.column "initial_report",  :text
    t.column "conversation_id", :integer
    t.column "status",          :boolean
    t.column "email_id",        :integer
    t.column "date",            :datetime
    end
  end

  def self.down
    drop_table :tickets
  end
end
