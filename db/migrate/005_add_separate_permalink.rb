class AddSeparatePermalink < ActiveRecord::Migration
  def self.up
  	add_column :contents, :link, :string
  end

  def self.down
  	remove_column :contents, :link
  end
end
