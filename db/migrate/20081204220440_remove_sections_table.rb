class RemoveSectionsTable < ActiveRecord::Migration
  def self.up
  	drop_table :sections
  end

  def self.down
  	raise ActiveRecord::IrreversibleMigration
  end
end
