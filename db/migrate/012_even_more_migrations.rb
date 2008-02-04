class EvenMoreMigrations < ActiveRecord::Migration
  def self.up
  	 execute "alter table comments add constraint fk_content_comments foreign key (content_id) references contents(id)"
  end

  def self.down
  end
end
