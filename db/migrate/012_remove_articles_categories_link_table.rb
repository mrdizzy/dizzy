class RemoveArticlesCategoriesLinkTable < ActiveRecord::Migration
  def self.up
  	drop_table "articles_categories"
  end

  def self.down
  	  create_table "articles_categories", :id => false, :force => true do |t|
    t.column "category_id", :integer
    t.column "article_id",  :integer
  end

  add_index "articles_categories", ["category_id"], :name => "articles_category_id"
  add_index "articles_categories", ["article_id"], :name => "article_id"
  end
end
