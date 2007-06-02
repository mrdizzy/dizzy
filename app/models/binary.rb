# == Schema Information
# Schema version: 19
#
# Table name: binaries
#
#  id           :integer(11)   not null, primary key
#  binary       :binary        
#  content_type :string(255)   
#  size         :string(255)   
#  filename     :string(255)   
#

class Binary < ActiveRecord::Base
	
		def uploaded_data=(binary_data)
		self.filename = binary_data.original_filename
		self.size = binary_data.size
		self.content_type = binary_data.content_type.chomp
		self.binary = binary_data.read
	end
end
