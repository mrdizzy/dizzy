class RemoveCheatsheets < ActiveRecord::Migration
  def self.up
  	drop_table :categories_cheatsheets
  end

  def self.down
   create_table "categories_cheatsheets", :id => false, :force => true do |t|
    t.column "category_id",   :integer
    t.column "cheatsheet_id", :integer
  end
  end
end
