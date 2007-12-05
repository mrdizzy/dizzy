class CategoriesContent < ActiveRecord::Base
	belongs_to :content,  :order => "date DESC"
	belongs_to :category
	
end
