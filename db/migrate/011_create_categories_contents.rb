class CreateCategoriesContents < ActiveRecord::Migration
  def self.up
    create_table :categories_contents, :id => false, :force => true do |t|
    	  
    t.column "category_id", :integer
    t.column "content_id",  :integer
    end
  end

  def self.down
    drop_table :categories_contents
  end
end
