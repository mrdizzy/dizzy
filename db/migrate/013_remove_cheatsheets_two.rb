class RemoveCheatsheetsTwo < ActiveRecord::Migration
  def self.up
  	drop_table :cheatsheets
  end

  def self.down
  	
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

  end
end
