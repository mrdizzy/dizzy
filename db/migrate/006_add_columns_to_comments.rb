class AddColumnsToComments < ActiveRecord::Migration
  def self.up
  	add_column :comments, :content, :string
  	add_column :comments, :subject, :string
  	add_column :comments, :email, :string
  	add_column :comments, :parent_id, :integer, :references => nil
  end

  def self.down
  	drop_column :comments, :content
  	drop_column :comments, :email
  	drop_column :comments, :subject
  	drop_column :comments, :parent_id
  end
end
