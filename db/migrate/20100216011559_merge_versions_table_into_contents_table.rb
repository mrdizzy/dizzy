class MergeVersionsTableIntoContentsTable < ActiveRecord::Migration
  def self.up
     execute "ALTER TABLE contents DROP FOREIGN KEY contents_ibfk_1"
    rename_column :contents, :version_id, :version
    drop_table :versions
  end

  def self.down
  end
end
