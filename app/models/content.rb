class Content < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :related_articles, :class_name => "Content", :foreign_key => "related_id"
	has_many 				:comments, :dependent => :destroy, :order => "'created_at' DESC"
	belongs_to 				:version
	
	validates_existence_of	:version
	validates_presence_of 	:content	 
	validates_presence_of 	:category_ids
	validates_format_of		:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	validates_presence_of 	:title, :description, :date, :user, :permalink, :version_id 
	validates_uniqueness_of :permalink	

	named_scope :recent, lambda { { :conditions => ["date < ?", 1.hour.ago], :order => "date DESC"  } }
  
	before_save :create_new_version
	
	attr_accessor :new_version
	
	def main_category
		self.categories.first
	end
	
	def create_new_version
		create_version(:version_number => new_version) unless new_version.blank?
	end
	
	def parsed_content
		result = "Use numbered headers: true
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}

" + self.content
		result = Maruku.new(result).to_html

	end
end

class Article < Content
end
