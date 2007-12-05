class AddPrimaryKeyToLinks < ActiveRecord::Migration
  def self.up
  	change_column :categories_contents, :id, :primary_key  
  end

  def self.down
  	change_column :categories_contents, :id, :integer
  end
end
