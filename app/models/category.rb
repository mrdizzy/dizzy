class Category < ActiveRecord::Base
	has_and_belongs_to_many :contents, :order => "date DESC"
   
    default_scope :order => :name
   
	validates_presence_of 		:permalink, :name
	validates_uniqueness_of 	:permalink, :name, :allow_blank => true
	validates_format_of			:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
end
