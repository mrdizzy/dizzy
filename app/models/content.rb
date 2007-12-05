class Content < ActiveRecord::Base
	has_many :categories_contents, :dependent => :destroy
	has_many :categories, :through => :categories_contents
	has_many :comments, :dependent => :destroy
	has_one :pdf, :dependent => :destroy
	has_one :thumbnail, :dependent => :destroy	
	has_permalink :title 
		
	belongs_to :user
	validates_uniqueness_of :title, :permalink
	
	def related_article
		related_article = CategoriesContent.find_by_category_id(self.main_category, :limit => 1, :order => "id DESC")
		related_article.content
	end
	
	def main_category
		main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)	
		main_category.category_id unless main_category.nil?
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
		current_main_category = CategoriesContent.find_by_content_id_and_main(self.id, 1)
		CategoriesContent.delete(current_main_category.id)
		new_main_category = CategoriesContent.create(:content_id => self.id, :main => 1, :category_id => object_id)
		self.categories_contents << new_main_category
	end	
end

class Article < Content
	validates_presence_of :content, :title, :date, :user_id, :description, :permalink
end

class Cheatsheet < Content

	validates_presence_of :title, :description, :permalink, :content, :date, :user_id, :date
	
	def thumbnail_data=(binary_data)
		unless binary_data.blank?		
			
			self.thumbnail = binary_data.read
			self.thumbnail_size = binary_data.size
		end
	end
end