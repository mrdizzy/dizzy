class Cheatsheet < ActiveRecord::Base
	has_and_belongs_to_many :categories
	belongs_to :author
	
		def thumbnail_data=(binary_data)
		unless binary_data.blank?
			self.thumbnail_content_type = binary_data.content_type.chomp
			self.thumbnail = binary_data.read
			self.thumbnail_size = binary_data.size
		end
	end
		def pdf_data=(binary_data)
			unless binary_data.blank?
		self.filename = binary_data.original_filename
		self.content_type = binary_data.content_type.chomp
		self.pdf = binary_data.read
		self.size = binary_data.size
	end
	end	
end
