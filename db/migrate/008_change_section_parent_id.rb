class ChangeSectionParentId < ActiveRecord::Migration
  def self.up
  	rename_column :sections, :cheatsheet_id, :content_id
  end

  def self.down
  	rename_column :sections, :content_id, :cheatsheet_id
  end
end
