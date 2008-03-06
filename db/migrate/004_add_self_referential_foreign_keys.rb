class AddSelfReferentialForeignKeys < ActiveRecord::Migration
  def self.up
  	  	execute "alter table contents_contents add constraint fk_main_content_contents foreign key (content_id) references contents(id)"
  	execute "alter table contents_contents add constraint fk_secondary_content_contents foreign key (related_id) references contents(id)"
  end

  def self.down
  end
end
