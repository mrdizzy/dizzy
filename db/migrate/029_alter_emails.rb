class AlterEmails < ActiveRecord::Migration
  def self.up
  	rename_column :emails, :customer_id, :person_id
  end

  def self.down
  	rename_column :emails, :person_id, :customer_id
  end
end
