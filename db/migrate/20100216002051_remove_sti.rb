class RemoveSti < ActiveRecord::Migration
  def self.up
    rename_column :contents, :type, :layout
  end

  def self.down
  rename_column :contents, :layout, :type
  end
end
