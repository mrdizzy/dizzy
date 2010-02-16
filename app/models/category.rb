class Category < ActiveRecord::Base
	has_and_belongs_to_many :contents, :order => "date DESC"
   
    default_scope :order => :name
   
	validates_presence_of 		:permalink, :name
	validates_uniqueness_of 	:permalink, :name, :allow_blank => true
	validates_format_of			:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	
	def to_param
		permalink
	end
end


# == Schema Info
# Schema version: 20090919133116
#
# Table name: categories
#
#  id        :integer(4)      not null, primary key
#  name      :string(255)
#  permalink :string(255)