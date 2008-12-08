class RefactorUsers < ActiveRecord::Migration
  def self.up
  	execute "ALTER TABLE contents DROP FOREIGN KEY fk_user_contents;"
  	remove_column :contents, :user_id
  	drop_table :users
  	add_column :contents, :user, :string
  	contents = Content.all
  	contents.each do |content|
  		content.user = "mr_dizzy"
  		content.save!
  	end
  end

  def self.down
  end
end
