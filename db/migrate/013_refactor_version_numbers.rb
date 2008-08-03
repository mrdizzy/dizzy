class RefactorVersionNumbers < ActiveRecord::Migration
  def self.up
  	
  Content.inheritance_column = 'disable_single_table_inheritance'
  
  contents = Content.find_all_by_version_id([3,4,5])
  contents.each do |content|
  	content.version_id = 3
  	content.save!
  end
  
  Version.find(4).destroy
  Version.find(5).destroy
  
  end

  def self.down
  	
  end
end
