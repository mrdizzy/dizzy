class DropBinariesTable < ActiveRecord::Migration
  def self.up
  	   drop_table :binaries
  end

  def self.down

  create_table "binaries", :force => true do |t|
    t.column "binary",       :binary
    t.column "content_type", :string
    t.column "size",         :string
    t.column "filename",     :string
  end
  end
end
