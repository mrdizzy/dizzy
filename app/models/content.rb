class Content < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_many :comments
	has_one :content_binary
	has_permalink :title 
		
	belongs_to :user
	validates_uniqueness_of :title, :permalink
end

class Article < Content
	validates_presence_of :content, :title, :date, :user_id, :description, :permalink
end

class Cheatsheet < Content

	validates_presence_of :title, :description, :permalink, :content, :date, :user_id, :date
	
	def thumbnail_data=(binary_data)
		unless binary_data.blank?		
			
			self.thumbnail = binary_data.read
			self.thumbnail_size = binary_data.size
		end
	end
end