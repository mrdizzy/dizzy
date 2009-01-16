# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090116001346) do

  create_table "binaries", :force => true do |t|
    t.binary  "binary_data",  :limit => 16777215
    t.string  "type"
    t.string  "content_type"
    t.integer "size"
    t.string  "filename"
    t.integer "content_id",                       :default => 0, :null => false
  end

  add_index "binaries", ["content_id"], :name => "fk_content_binaries"

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "permalink"
  end

  create_table "categories_contents", :id => false, :force => true do |t|
    t.integer "category_id", :default => 0, :null => false
    t.integer "content_id",  :default => 0, :null => false
  end

  add_index "categories_contents", ["content_id"], :name => "fk_content_categories_contents"
  add_index "categories_contents", ["category_id"], :name => "fk_category_categories_contents"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.string   "subject"
    t.string   "email"
    t.integer  "parent_id"
    t.integer  "content_id", :default => 0,    :null => false
    t.datetime "created_at"
    t.boolean  "new",        :default => true
    t.string   "name"
  end

  add_index "comments", ["content_id"], :name => "fk_content_comments"
  add_index "comments", ["parent_id"], :name => "fk_comment_comments"

  create_table "companies", :force => true do |t|
    t.string  "name",        :limit => 40
    t.string  "description"
    t.boolean "visible",                   :default => false
  end

  create_table "contents", :force => true do |t|
    t.string   "type"
    t.string   "title"
    t.string   "description"
    t.datetime "date"
    t.text     "content"
    t.string   "permalink"
    t.integer  "version_id"
    t.string   "style"
    t.string   "user"
  end

  create_table "contents_contents", :id => false, :force => true do |t|
    t.integer "content_id", :default => 0, :null => false
    t.integer "related_id", :default => 0, :null => false
  end

  add_index "contents_contents", ["related_id"], :name => "fk_secondary_content_contents"
  add_index "contents_contents", ["content_id"], :name => "fk_main_content_contents"

  create_table "markdowns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "message"
    t.string   "email"
  end

  create_table "portfolio_items", :force => true do |t|
    t.integer "portfolio_type_id", :default => 0, :null => false
    t.integer "company_id",        :default => 0, :null => false
    t.integer "size"
    t.binary  "data"
  end

  add_index "portfolio_items", ["portfolio_type_id"], :name => "portfolio_type_id"
  add_index "portfolio_items", ["company_id"], :name => "company_id"

  create_table "portfolio_types", :force => true do |t|
    t.string  "description",   :limit => 40
    t.integer "column_space"
    t.integer "position"
    t.binary  "header_binary"
    t.boolean "visible",                     :default => true
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version"
  end

  create_table "versions", :force => true do |t|
    t.string "version_number"
  end

end
