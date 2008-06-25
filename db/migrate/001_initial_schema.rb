class InitialSchema < ActiveRecord::Migration
  def self.up 
  
    create_table "binaries", :force => true do |t|
      t.column "binary_data",  :binary
      t.column "type",         :string
      t.column "content_type", :string
      t.column "size",         :integer
      t.column "filename",     :string
      t.column "content_id",   :integer
    end
  
    add_index "binaries", ["content_id"], :name => "fk_content_binaries"
  
    create_table "categories", :force => true do |t|
      t.column "name",      :string
      t.column "permalink", :string
    end
  
    create_table "categories_contents", :id => false, :force => true do |t|
      t.column "category_id", :integer
      t.column "content_id",  :integer
    end
  
    add_index "categories_contents", ["content_id"], :name => "fk_content_categories_contents"
    add_index "categories_contents", ["category_id"], :name => "fk_category_categories_contents"
  
    create_table "comments", :force => true do |t|
      t.column "body",       :text
      t.column "subject",    :string
      t.column "email",      :string
      t.column "parent_id",  :integer
      t.column "content_id", :integer
      t.column "created_at", :datetime
      t.column "new",        :boolean,  :default => true
      t.column "name",       :string
    end
  
    add_index "comments", ["content_id"], :name => "fk_content_comments"
  
    create_table "companies", :force => true do |t|
      t.column "name",        :string, :limit => 40
      t.column "description", :string
    end
  
    create_table "contents", :force => true do |t|
      t.column "type",        :string
      t.column "title",       :string
      t.column "description", :string
      t.column "user_id",     :integer
      t.column "date",        :datetime
      t.column "content",     :text
      t.column "permalink",   :string
      t.column "version_id",  :integer
    end
  
    add_index "contents", ["user_id"], :name => "fk_user_contents"
  
    create_table "contents_contents", :id => false, :force => true do |t|
      t.column "content_id", :integer
      t.column "related_id", :integer
    end
  
    add_index "contents_contents", ["related_id"], :name => "fk_secondary_content_contents"
    add_index "contents_contents", ["content_id"], :name => "fk_main_content_contents"
  
    create_table "conversations", :force => true do |t|
      t.column "subject",    :string
      t.column "name",       :string
      t.column "created_at", :datetime
      t.column "email",      :string
      t.column "body",       :text
    end
  
    create_table "polls", :force => true do |t|
      t.column "name",       :string
      t.column "created_at", :datetime
    end
  
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
  
    create_table "portfolio_types", :force => true do |t|
      t.column "description",         :string,  :limit => 40
      t.column "column_space",        :integer
      t.column "position",            :integer
      t.column "header_binary",       :binary
      t.column "header_filename",     :string
      t.column "header_content_type", :string
      t.column "visible",             :boolean,               :default => true
    end
  
    create_table "sections", :force => true do |t|
      t.column "body",       :text
      t.column "content_id", :integer
      t.column "title",      :string
      t.column "summary",    :string
      t.column "permalink",  :string
    end
  
    add_index "sections", ["content_id"], :name => "fk_content_sections"
  
    create_table "sessions", :force => true do |t|
      t.column "session_id", :string
      t.column "data",       :text
      t.column "updated_at", :datetime
    end
  
    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
  
    create_table "users", :force => true do |t|
      t.column "name",            :string
      t.column "hashed_password", :string
      t.column "salt",            :string
      t.column "firstname",       :string
      t.column "surname",         :string
      t.column "email",           :string
    end
  
    create_table "versions", :force => true do |t|
      t.column "version_number", :string
    end
  
    create_table "votes", :force => true do |t|
      t.column "poll_id", :integer
      t.column "option",  :string
      t.column "total",   :integer
    end
  
  end

  def self.down
    drop_table :binaries
    drop_table :categories
    drop_table :categories_contents
    drop_table :comments
    drop_table :companies
    drop_table :contents
    drop_table :contents_contents
    drop_table :conversations
    drop_table :polls
    drop_table :portfolio_items
    drop_table :portfolio_types
    drop_table :sections
    drop_table :sessions
    drop_table :users
    drop_table :versions
    drop_table :votes
  end
end
