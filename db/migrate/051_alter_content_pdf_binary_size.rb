class AlterContentPdfBinarySize < ActiveRecord::Migration
  def self.up
  	change_column :contents, :pdf, :binary, :limit => 1.megabyte
  end

  def self.down
  	change_column :contents, :pdf, :binary
  end
end
