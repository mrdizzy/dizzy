class AddRelatedArticles < ActiveRecord::Migration
  def self.up
  	create_table "contents_contents", :force => true, :id => false do |t|
	    t.column "content_id",      :integer
	    t.column "related_id", 		:integer
  	end
  end

  def self.down
  	drop_table :related_articles
  end
end
