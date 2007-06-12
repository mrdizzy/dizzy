class AddFkToCheatsheets < ActiveRecord::Migration
  def self.up
  	  	  execute "alter table cheatsheets
add constraint fk_cheatsheets_authors
foreign key (author_id) references authors(id)"  
  end

  def self.down
  end
end
