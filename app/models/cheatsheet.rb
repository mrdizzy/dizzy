# == Schema Information
# Schema version: 34
#
# Table name: cheatsheets
#
#  id                     :integer(11)   not null, primary key
#  thumbnail              :binary        
#  pdf                    :binary        
#  title                  :string(255)   
#  description            :string(255)   
#  author_id              :integer(11)   
#  date                   :datetime      
#  filename               :string(255)   
#  content_type           :string(255)   
#  size                   :integer(11)   
#  thumbnail_size         :integer(11)   
#  thumbnail_content_type :string(255)   
#  counter                :integer(11)   
#  content                :text          
#  permalink              :string(255)   
#

class Cheatsheet < ActiveRecord::Base
	has_permalink :title 
	has_and_belongs_to_many :categories
	belongs_to :author
	validates_presence_of :title, :description, :permalink, :content, :author_id, :date
	
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
