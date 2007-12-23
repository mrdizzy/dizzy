# == Schema Information
# Schema version: 6
#
# Table name: categories_contents
#
#  category_id :integer(11)   
#  content_id  :integer(11)   
#  main        :boolean(1)    
#  id          :integer(11)   not null, primary key
#

class CategoriesContent < ActiveRecord::Base
	belongs_to :content,  :order => "date DESC"
	belongs_to :category
	validates_uniqueness_of :category_id, :scope => :content_id
end
