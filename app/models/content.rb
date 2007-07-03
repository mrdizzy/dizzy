class Content < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_many :comments
end

class Article < Content
	
		has_permalink :title
	#has_and_belongs_to_many :categories
	
	belongs_to :author
	
	validates_presence_of :content, :title, :date, :author_id, :description, :permalink
	validates_uniqueness_of :title, :permalink
end

class Cheatsheet < Content
		has_permalink :title 
		
	#has_and_belongs_to_many :categories
	belongs_to :author
	validates_presence_of :title, :description, :permalink, :content, :author_id, :date, :thumbnail, :pdf, :size, :author_id, :date, :filename, :thumbnail_size
	
	def thumbnail_data=(binary_data)
		unless binary_data.blank?		
			
			self.thumbnail = binary_data.read
			self.thumbnail_size = binary_data.size
		end
	end
		
	def pdf_data=(binary_data)
		unless binary_data.blank?
			self.filename = binary_data.original_filename			
			self.pdf = binary_data.read
			self.size = binary_data.size
		end
	end
end