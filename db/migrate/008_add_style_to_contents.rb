class AddStyleToContents < ActiveRecord::Migration
  
  def self.up
  	add_column :contents, :style, :string
  end

  def self.down
  	remove_column :contents, :style
  end
end
