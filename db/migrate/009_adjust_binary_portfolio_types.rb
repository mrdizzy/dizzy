class AdjustBinaryPortfolioTypes < ActiveRecord::Migration
  def self.up
  	remove_column :portfolio_types, :header_image
  	add_column :portfolio_types, :header_binary, :binary
  	add_column :portfolio_types, :header_filename, :string
  	add_column :portfolio_types, :header_content_type, :string
  end

  def self.down
  	add_column :portfolio_types, :header_image, :binary
  end
end
