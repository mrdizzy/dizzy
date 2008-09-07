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

ActiveRecord::Schema.define(:version => 13) do

  create_table "binaries", :force => true do |t|
    t.binary  "binary_data",  :limit => 16777215
    t.string  "type"
    t.string  "content_type"
    t.integer "size",         :limit => 11
    t.string  "filename"
    t.integer "content_id",   :limit => 11,       :default => 0, :null => false
  end

  add_index "binaries", ["content_id"], :name => "fk_content_binaries"

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "permalink"
  end

  create_table "categories_contents", :id => false, :force => true do |t|
    t.integer "category_id", :limit => 11, :default => 0, :null => false
    t.integer "content_id",  :limit => 11, :default => 0, :null => false
  end

  add_index "categories_contents", ["content_id"], :name => "fk_content_categories_contents"
  add_index "categories_contents", ["category_id"], :name => "fk_category_categories_contents"

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.string   "subject"
    t.string   "email"
    t.integer  "parent_id",  :limit => 11
    t.integer  "content_id", :limit => 11, :default => 0,    :null => false
    t.datetime "created_at"
    t.boolean  "new",                      :default => true
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
    t.integer  "user_id",     :limit => 11
    t.datetime "date"
    t.text     "content"
    t.string   "permalink"
    t.integer  "version_id",  :limit => 11
    t.string   "style"
  end

  add_index "contents", ["user_id"], :name => "fk_user_contents"

  create_table "contents_contents", :id => false, :force => true do |t|
    t.integer "content_id", :limit => 11, :default => 0, :null => false
    t.integer "related_id", :limit => 11, :default => 0, :null => false
  end

  add_index "contents_contents", ["related_id"], :name => "fk_secondary_content_contents"
  add_index "contents_contents", ["content_id"], :name => "fk_main_content_contents"

  create_table "portfolio_items", :force => true do |t|
    t.integer "portfolio_type_id", :limit => 11, :default => 0, :null => false
    t.integer "company_id",        :limit => 11, :default => 0, :null => false
    t.string  "content_type"
    t.string  "filename"
    t.integer "size",              :limit => 11
    t.binary  "data"
  end

  add_index "portfolio_items", ["portfolio_type_id"], :name => "portfolio_type_id"
  add_index "portfolio_items", ["company_id"], :name => "company_id"

  create_table "portfolio_types", :force => true do |t|
    t.string  "description",         :limit => 40
    t.integer "column_space",        :limit => 11
    t.integer "position",            :limit => 11
    t.binary  "header_binary"
    t.string  "header_filename"
    t.string  "header_content_type"
    t.boolean "visible",                           :default => true
  end

  create_table "schema_info", :id => false, :force => true do |t|
    t.integer "version", :limit => 11
  end

  create_table "sections", :force => true do |t|
    t.text    "body"
    t.integer "content_id", :limit => 11, :default => 0, :null => false
    t.string  "title"
    t.string  "summary"
    t.string  "permalink"
  end

  add_index "sections", ["content_id"], :name => "fk_content_sections"

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "hashed_password"
    t.string "salt"
    t.string "firstname"
    t.string "surname"
    t.string "email"
  end

  create_table "versions", :force => true do |t|
    t.string "version_number"
  end

end
