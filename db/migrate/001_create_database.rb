class CreateDatabase < ActiveRecord::Migration
  def self.up
  	
  create_table "authors", :force => true do |t|
    t.column "username",  :string
    t.column "firstname", :string
    t.column "surname",   :string
    t.column "email",     :string
  end  	
  
  create_table "binaries", :force => true do |t|
    t.column "binary",       :binary
    t.column "content_type", :string
    t.column "size",         :string
    t.column "filename",     :string
  end

  create_table "categories", :force => true do |t|
    t.column "name",      :string
    t.column "permalink", :string
  end

 create_table "comments", :force => true do |t|
  end

  create_table "companies", :force => true do |t|
    t.column "name",        :string, :limit => 40
    t.column "description", :string
  end


  create_table "cheatsheets", :force => true do |t|
    t.column "thumbnail",              :binary
    t.column "pdf",                    :binary
    t.column "title",                  :string
    t.column "description",            :string
    t.column "author_id",              :integer
    t.column "date",                   :datetime
    t.column "filename",               :string
    t.column "content_type",           :string
    t.column "size",                   :integer
    t.column "thumbnail_size",         :integer
    t.column "thumbnail_content_type", :string
    t.column "counter",                :integer
    t.column "content",                :text
    t.column "permalink",              :string
  end

  create_table "portfolio_types", :force => true do |t|
    t.column "description",         :string,  :limit => 40
    t.column "column_space",        :integer
    t.column "position",            :integer
    t.column "header_binary",       :binary
    t.column "header_filename",     :string
    t.column "header_content_type", :string
    t.column "visible",             :boolean,               :default => true
  end
  
  add_index "cheatsheets", ["author_id"], :name => "author_id"
  
  create_table "articles", :force => true do |t|
    t.column "title",     :string
    t.column "content",   :text
    t.column "date",      :datetime
    t.column "author_id", :integer
    t.column "excerpt",   :text
    t.column "permalink", :string
  end

  add_index "articles", ["author_id"], :name => "author_id"

  create_table "articles_categories", :id => false, :force => true do |t|
    t.column "category_id", :integer
    t.column "article_id",  :integer
  end

  add_index "articles_categories", ["category_id"], :name => "category_id"
  add_index "articles_categories", ["article_id"], :name => "article_id"

  create_table "categories_cheatsheets", :id => false, :force => true do |t|
    t.column "category_id",   :integer
    t.column "cheatsheet_id", :integer
  end

  add_index "categories_cheatsheets", ["category_id"], :name => "category_id"
  add_index "categories_cheatsheets", ["cheatsheet_id"], :name => "cheatsheet_id"
 
  create_table "portfolio_items", :force => true do |t|
    t.column "portfolio_type_id", :integer
    t.column "company_id",        :integer
    t.column "content_type",      :string
    t.column "filename",          :string
    t.column "size",              :integer
    t.column "data",              :binary
  end

  add_index "portfolio_items", ["portfolio_type_id"], :name => "portfolio_type_id"
  add_index "portfolio_items", ["company_id"], :name => "company_id"

  end

  def self.down
  	drop_table :portfolio_items
  	drop_table :categories_cheatsheets
  	drop_table :articles_categories
  	drop_table :articles
  	drop_table :categories
  	drop_table :companies
  	drop_table :portfolio_types
  	drop_table :binaries
  	drop_table :authors
  	drop_table :cheatsheets
  	drop_table :comments
  end
end
