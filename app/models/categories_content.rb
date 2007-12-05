class CategoriesContent < ActiveRecord::Base
	belongs_to :content,  :order => "date DESC"
	belongs_to :category
	validates_uniqueness_of :category_id, :scope => :content_id
end
