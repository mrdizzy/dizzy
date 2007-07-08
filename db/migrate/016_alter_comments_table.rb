class AlterCommentsTable < ActiveRecord::Migration
  def self.up
  	rename_column :comments, :content, :body
  end

  def self.down
  	rename_column :comments, :body, :content
  end
end
