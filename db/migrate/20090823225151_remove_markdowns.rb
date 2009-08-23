class RemoveMarkdowns < ActiveRecord::Migration
  def self.up
   drop_table :markdowns
  end

  def self.down
  end
end
