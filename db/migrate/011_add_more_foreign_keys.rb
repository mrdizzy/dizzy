class AddMoreForeignKeys < ActiveRecord::Migration
  def self.up
  	  	 execute "alter table binaries add constraint fk_content_binaries foreign key (content_id) references contents(id)"
  	  	  execute "alter table contents add constraint fk_user_contents foreign key (user_id) references users(id)"
  end

  def self.down
  end
end
