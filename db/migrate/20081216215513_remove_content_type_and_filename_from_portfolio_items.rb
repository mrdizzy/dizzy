class RemoveContentTypeAndFilenameFromPortfolioItems < ActiveRecord::Migration
  def self.up
  	remove_column :portfolio_items, :content_type
  	remove_column :portfolio_items, :filename
  end

  def self.down
  end
end
