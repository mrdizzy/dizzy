class ArticlesCategories < ActiveRecord::Migration
  def self.up
  	create_table :articles_categories, :id => false do |t|
  		t.column :category_id, :integer
  		t.column :article_id, :integer
  		end
  end

  def self.down
  	drop_table :articles_categories
  end
end
