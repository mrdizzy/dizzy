# == Schema Information
# Schema version: 6
#
# Table name: contents
#
#  id          :integer(11)   not null, primary key
#  type        :string(255)   
#  title       :string(255)   
#  description :string(255)   
#  user_id     :integer(11)   
#  date        :datetime      
#  content     :text          
#  permalink   :string(255)   
#

class Content < ActiveRecord::Base
	has_many :categories_contents, :dependent => :destroy
	has_many :categories, :through => :categories_contents
	has_many :comments, :dependent => :destroy
	has_many :sections, :dependent => :destroy, :order => "'title' ASC"
	
	validates_presence_of :content, :title,  :description, :date, :user_id, :permalink
    
	belongs_to :user
	validates_uniqueness_of :permalink	
	
	def related_article
		related_article = CategoriesContent.find_by_category_id(self.main_category, :limit => 1, :order => "id DESC")
		related_article.content
	end
	
	def main_category_name 
		main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)	
		main_category.category.name unless main_category.nil?
	end
	
	def main_category
		main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)	
		@main_category = main_category.category_id unless main_category.nil?
		@main_category
	end
	
	def main_category_permalink
		main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)	
		main_category.category.permalink unless main_category.nil?
	end
	
	def subcategories
		results = CategoriesContent.find_all_by_content_id_and_main(self.id, nil)
		unless results.nil?
			results.map(&:category_id)		
		end
	end
	
	def subcategories=(object_ids)
		current_subcategories = CategoriesContent.find_all_by_content_id_and_main(self.id, nil)
		CategoriesContent.delete(current_subcategories)
		
		object_ids.each do |object_id|
			linked_subcategory = CategoriesContent.new(:main => nil, :content_id => self.id, :category_id => object_id)
			self.categories_contents << linked_subcategory		
		end
	end
	
	def main_category=(object_id)	
		if (self.id)
			current_main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)
			CategoriesContent.delete(current_main_category.id) unless current_main_category.nil?
		end
		new_main_category = CategoriesContent.new(:content_id => self.id, :main => 1, :category_id => object_id)
		self.categories_contents << new_main_category
	end		
end

class Article < Content
end

class Cheatsheet < Content
	has_one :pdf, :dependent => :destroy, :foreign_key => "content_id"
	has_one :thumbnail, :dependent => :destroy, :foreign_key => "content_id"
end
