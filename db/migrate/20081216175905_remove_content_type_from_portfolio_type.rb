class RemoveContentTypeFromPortfolioType < ActiveRecord::Migration
  def self.up
  	remove_column :portfolio_types, :header_content_type
  end

  def self.down
  end
end
