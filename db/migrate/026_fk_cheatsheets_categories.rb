class FkCheatsheetsCategories < ActiveRecord::Migration
  def self.up
 	  	  execute "alter table categories_cheatsheets
add constraint fk_categories_cheatsheets_categories
foreign key (category_id) references categories(id)"  	
  execute "alter table categories_cheatsheets
add constraint fk_categories_cheatsheets_cheatsheets
foreign key (cheatsheet_id) references cheatsheets(id)"  	
  end
  

  def self.down
  end
end
