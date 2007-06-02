class CreateBinaries < ActiveRecord::Migration
  def self.up
    create_table :binaries do |t|
    	t.column :binary, :binary
    	t.column :content_type, :string
    	t.column :size, :string
    	t.column :filename, :string
    end
  end

  def self.down
    drop_table :binaries
  end
end
