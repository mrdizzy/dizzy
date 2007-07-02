class Remove < ActiveRecord::Migration
  def self.up
  	drop_table :articles_categories
  	drop_table :articles
  end

  def self.down
  	
  create_table "articles", :force => true do |t|
    t.column "title",     :string
    t.column "content",   :text
    t.column "date",      :datetime
    t.column "author_id", :integer
    t.column "excerpt",   :text
    t.column "permalink", :string
  end
    create_table "articles_categories", :id => false, :force => true do |t|
    t.column "category_id", :integer
    t.column "article_id",  :integer
  end

  end
end
