class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
  	  execute "alter table articles
add constraint fk_articles_authors
foreign key (author_id) references authors(id)"  

  end

  def self.down
  end
end
