class RemoveBinariesFromContents < ActiveRecord::Migration
  def self.up
  	remove_column :contents, :size
  	remove_column :contents, :pdf
  end

  def self.down
  end
end
