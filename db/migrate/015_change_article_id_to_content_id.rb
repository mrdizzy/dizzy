class ChangeArticleIdToContentId < ActiveRecord::Migration
  def self.up
  	rename_column :comments, :article_id, :content_id
  end

  def self.down
  	rename_column :comments,  :content_id, :article_id
  end
end
