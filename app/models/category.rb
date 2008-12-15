# == Schema Information
# Schema version: 20081208231312
#
# Table name: categories
#
#  id        :integer(4)    not null, primary key
#  name      :string(255)   
#  permalink :string(255)   
#

class Category < ActiveRecord::Base
	has_and_belongs_to_many :contents, :order => "date DESC"
	validates_presence_of 		:permalink, :name
	validates_uniqueness_of 	:permalink, :name, :allow_blank => true
	validates_format_of			:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	
	def self.find_by_permalink(id)
		result = find(:first, :conditions => ["permalink = ?", id])
		unless result 
			raise ActiveRecord::RecordNotFound 
		else
			result
		end	
	end
end
