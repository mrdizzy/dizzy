class RemoveLinkFromContents < ActiveRecord::Migration
  def self.up
  	  	remove_column :contents, :link
  end

  def self.down
  	  	add_column :contents, :link, :string
  end
end
