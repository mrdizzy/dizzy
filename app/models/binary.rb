# == Schema Information
# Schema version: 4
#
# Table name: binaries
#
#  id           :integer(11)   not null, primary key
#  binary_data  :binary        
#  type         :string(255)   
#  content_type :string(255)   
#  size         :integer(11)   
#  filename     :string(255)   
#  content_id   :integer(11)   
#

class Binary < ActiveRecord::Base
	validates_presence_of :binary_data, :content_type, :size, :filename, :content_id
	belongs_to :content
	
	validates_existence_of :content, :on => :update

	def uploaded_data=(binary_data)
			self.filename 		= binary_data.original_filename
			self.content_type 	= binary_data.content_type.chomp
			self.binary_data 	= binary_data.read
			self.size			= binary_data.size
	end
end

class Thumbnail < Binary
	validates_inclusion_of :size, :in => 1.kilobyte..40.kilobytes, :message => "must be between 1k and 40k" 
	validates_format_of :content_type, :with => /image\/png/, :message => "must be a PNG image file"
end

class Pdf < Binary
	validates_inclusion_of :size, :in => 1.kilobyte..700.kilobytes, :message => "must be between 1k and 700k"
	validates_format_of :content_type, :with => /(application\/pdf|binary\/octet-stream)/, :message => "must be a PDF file"
end
