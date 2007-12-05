class CategoriesContent < ActiveRecord::Base
	belongs_to :contents,  :order => "date DESC"
	belongs_to :categories
	
	has_permalink :name
	
	validates_uniqueness_of :name
	validates_presence_of :name
end
