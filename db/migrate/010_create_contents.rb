class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
    	t.column :type, 	:string
    	
	#common attributes
    t.column "title",                  :string
    t.column "description",            :string
    t.column "author_id",              :integer
    t.column "date",                   :datetime
    t.column "content",                :text  
    
    # attributes for type=Cheatsheet
    t.column "filename",               :string
    t.column "content_type",           :string
    t.column "size",                   :integer
    t.column "thumbnail_size",         :integer
    t.column "thumbnail",              :binary
    t.column "pdf",                    :binary
    t.column "permalink",              :string    	
    end
  end

  def self.down
    drop_table :contents
  end
end