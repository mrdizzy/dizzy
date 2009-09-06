class RemoveBinaryHeaderFromPortfolioType < ActiveRecord::Migration
  def self.up
    remove_column :portfolio_types, :header_binary
  end

  def self.down
  end
end
