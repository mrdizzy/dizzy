class MakeCheatsheetsBlobLarger < ActiveRecord::Migration
  def self.up
  	change_column :cheatsheets, :pdf, :binary, :limit => 500.kilobyte
  end

  def self.down
  	change_column :cheatsheets, :pdf, :binary
  end
end
