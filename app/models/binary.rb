class Binary < ActiveRecord::Base
	
	def uploaded_data=(binary_data)
		self.filename = binary_data.original_filename
		self.content_type = binary_data.content_type.chomp
		self.binary_data = binary_data.read
		self.size	= binary_data.size
	end
end

class Thumbnail < Binary
	belongs_to :content
end

class Pdf < Binary
	belongs_to :content
end