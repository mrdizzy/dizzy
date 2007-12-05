class Binary < ActiveRecord::Base
	validates_presence_of :binary_data
	validates_presence_of :content_type
	validates_presence_of :size
	validates_presence_of :filename
	
	def uploaded_data=(binary_data)
		self.filename = binary_data.original_filename
		self.content_type = binary_data.content_type.chomp
		self.binary_data = binary_data.read
		self.size	= binary_data.size
	end
end

class Thumbnail < Binary
	belongs_to :content
	validates_format_of :content_type, :with => /image\/png/, :message => "Must be a PNG image file"
	validates_length_of :size,   :maximum => 100000
end

class Pdf < Binary
	belongs_to :content
	validates_length_of :size,   :maximum => 2000000
	validates_format_of :content_type, :with => /application\/pdf/, :message => "Must be a PDF file"
end