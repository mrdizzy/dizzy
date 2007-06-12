class AddColumnsToCheatsheet < ActiveRecord::Migration
  def self.up
  	add_column :cheatsheets, :thumbnail, :binary
  	add_column :cheatsheets, :pdf, :binary
  	add_column :cheatsheets, :title, :string
  	add_column :cheatsheets, :description, :string
  	add_column :cheatsheets, :category, :string
  	add_column :cheatsheets, :author_id, :integer
  	add_column :cheatsheets, :date, :datetime
  end

  def self.down
  	drop_column :cheatsheets, :thumbnail
  	drop_column :cheatsheets, :pdf
  	drop_column :cheatsheets, :title
  	drop_column :cheatsheets, :description
  	drop_column :cheatsheets, :category
  	drop_column :cheatsheets, :author_id
  	drop_column :cheatsheets, :date
  end
end
