class AddArticleIdToComments < ActiveRecord::Migration
  def self.up
  	add_column :comments, :article_id, :integer
  end

  def self.down
  	drop_column :comments, :article_id
  end
end
