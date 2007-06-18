class AddBooleanToPortfolioTypes < ActiveRecord::Migration
  def self.up
  	add_column :portfolio_types, :visible, :boolean, :default => 1
  end

  def self.down
  	remove_column :portfolio_types, :visible
  end
end
