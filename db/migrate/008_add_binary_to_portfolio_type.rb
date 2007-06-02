class AddBinaryToPortfolioType < ActiveRecord::Migration
  def self.up
  	add_column :portfolio_types, :header_image, :binary
  end

  def self.down
  	remove_column :portfolio_types, :header_image
  end
end
