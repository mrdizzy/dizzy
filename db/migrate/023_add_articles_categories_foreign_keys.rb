class AddArticlesCategoriesForeignKeys < ActiveRecord::Migration
  def self.up
  	  execute "alter table articles_categories
add constraint fk_articles_categories_categories
foreign key (category_id) references categories(id)"  
  	  execute "alter table articles_categories
add constraint fk_articles_categories_articles
foreign key (article_id) references articles(id)"  
  end

  def self.down
  end
end
