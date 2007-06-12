class AddThumbnailFieldsToCheatsheets < ActiveRecord::Migration
  def self.up
  	add_column :cheatsheets, :thumbnail_size, :integer
  	add_column :cheatsheets, :thumbnail_content_type, :string
  end

  def self.down
  	remove_column :cheatsheets, :thumbnail_size
  	remove_column :cheatsheets, :thumbnail_content_type
  end
end
