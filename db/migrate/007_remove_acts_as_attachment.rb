class RemoveActsAsAttachment < ActiveRecord::Migration
  def self.up
  		
  		  add_column :portfolio_items, :data, :binary
  end

  def self.down
  	
  		remove_column :portfolio_items, :data
end
end
