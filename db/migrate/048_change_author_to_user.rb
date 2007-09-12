class ChangeAuthorToUser < ActiveRecord::Migration
  def self.up
  	rename_column :contents, :author_id, :user_id
  end

  def self.down
  	rename_column :contents, :user_id, :author_id
  end
end
