class CreateContentBinaries < ActiveRecord::Migration
  def self.up
    create_table :content_binaries do |t|
    	t.column :binary_data, :binary, :limit => 5.megabytes
    	t.column :content_id, :integer
    end
  end

  def self.down
    drop_table :content_binaries
  end
end
