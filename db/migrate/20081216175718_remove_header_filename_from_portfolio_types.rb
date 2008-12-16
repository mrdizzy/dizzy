class RemoveHeaderFilenameFromPortfolioTypes < ActiveRecord::Migration
  def self.up
  	remove_column :portfolio_types, :header_filename
  end

  def self.down
  end
end
