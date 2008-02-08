class AddForeignKeys < ActiveRecord::Migration
  def self.up
  	 	execute "alter table categories_contents add constraint fk_content_categories_contents foreign key (content_id) references contents(id)"
  	 	execute "alter table categories_contents add constraint fk_category_categories_contents foreign key (category_id) references categories(id)"
  	 	execute "alter table binaries add constraint fk_content_binaries foreign key (content_id) references contents(id)"
  	  	execute "alter table contents add constraint fk_user_contents foreign key (user_id) references users(id)"  
  	  	execute "alter table comments add constraint fk_content_comments foreign key (content_id) references contents(id)"
  end

  def self.down
  end
end
