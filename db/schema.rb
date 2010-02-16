ActiveRecord::Schema.define(:version => 20100216011559) do

  create_table "categories", :force => true do |t|
    t.string "name"
    t.string "permalink"
  end

  create_table "categories_contents", :id => false, :force => true do |t|
    t.integer "category_id", :default => 0, :null => false
    t.integer "content_id",  :default => 0, :null => false
  end

  add_index "categories_contents", ["category_id"], :name => "category_id"
  add_index "categories_contents", ["content_id"], :name => "content_id"

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

  add_index "comments", ["content_id"], :name => "content_id"
  add_index "comments", ["parent_id"], :name => "parent_id"

  create_table "companies", :force => true do |t|
    t.string  "name",        :limit => 40
    t.string  "description"
    t.boolean "visible",                   :default => false
  end

  create_table "contents", :force => true do |t|
    t.string   "layout"
    t.string   "title"
    t.string   "description"
    t.datetime "date"
    t.text     "content"
    t.string   "permalink"
    t.integer  "version"
    t.string   "user"
    t.boolean  "has_toc"
    t.binary   "pdf_binary_data",  :limit => 16777215
    t.string   "pdf_filename"
    t.string   "pdf_content_type"
  end

  add_index "contents", ["version"], :name => "version_id"

  create_table "contents_contents", :id => false, :force => true do |t|
    t.integer "content_id", :default => 0, :null => false
    t.integer "related_id", :default => 0, :null => false
  end

  add_index "contents_contents", ["content_id"], :name => "content_id"
  add_index "contents_contents", ["related_id"], :name => "related_id"

  create_table "portfolio_items", :force => true do |t|
    t.integer "portfolio_type_id",  :default => 0, :null => false
    t.integer "company_id",         :default => 0, :null => false
    t.binary  "image_binary_data"
    t.string  "image_filename"
    t.string  "image_content_type"
  end

  add_index "portfolio_items", ["company_id"], :name => "company_id"
  add_index "portfolio_items", ["portfolio_type_id"], :name => "portfolio_type_id"

  create_table "portfolio_types", :force => true do |t|
    t.string  "description",  :limit => 40
    t.integer "column_space"
    t.integer "position"
    t.boolean "visible",                    :default => true
  end

end
