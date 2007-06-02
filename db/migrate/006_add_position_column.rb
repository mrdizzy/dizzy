class AddPositionColumn < ActiveRecord::Migration
  def self.up
    add_column :portfolio_types, :position, :integer
  end

  def self.down
      remove_column :portfolio_types, :position, :integer
  end
end
