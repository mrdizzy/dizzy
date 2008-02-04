class AddForeignKeys < ActiveRecord::Migration
  def self.up
  	 	execute "alter table categories_contents add constraint fk_content_categories_contents foreign key (content_id) references contents(id)"
  	 	  	 	execute "alter table categories_contents add constraint fk_category_categories_contents foreign key (category_id) references categories(id)"
  end

  def self.down
  end
end
