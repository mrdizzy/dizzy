class AddSectionsForeignKey < ActiveRecord::Migration
  def self.up
  	execute "alter table sections add constraint fk_content_sections foreign key (content_id) references contents(id)"
  end

  def self.down
  end
end
