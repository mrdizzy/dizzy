# == Schema Information
# Schema version: 13
#
# Table name: contents
#
#  id          :integer(4)    not null, primary key
#  type        :string(255)   
#  title       :string(255)   
#  description :string(255)   
#  user_id     :integer(4)    
#  date        :datetime      
#  content     :text          
#  permalink   :string(255)   
#  version_id  :integer(4)    
#  style       :string(255)   
#

class Content < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :related_articles, :class_name => "Content", :foreign_key => "related_id"
	has_many 				:comments, :dependent => :destroy, :order => "'created_at' DESC"
	belongs_to 				:version
	belongs_to 				:user
	
	validates_existence_of	:version
	validates_existence_of  :user	
	validates_presence_of 	:category_ids
	validates_format_of		:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	validates_presence_of 	:title, :description, :date, :user_id, :permalink, :version_id 
	validates_uniqueness_of :permalink	

	named_scope :recent, lambda { { :conditions => ["date < ?", 1.hour.ago], :order => "date DESC"  } }
	named_scope :snippets, :conditions => { :style => "SNIPPET" }, :order => "date DESC"
 	named_scope :tutorials, :conditions => { :style => "TUTORIAL"}, :order => "date DESC"
  
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

" + self.content
		result = Maruku.new(result).to_html

	end
end

class Article < Content
	validates_presence_of 	:content	
	validates_presence_of	:style
	validates_inclusion_of 	:style, :in => STYLES, :allow_blank => true
end

class Cheatsheet < Content
	
	has_one :pdf, :dependent => :destroy, :foreign_key => "content_id"
	has_one :thumbnail, :dependent => :destroy, :foreign_key => "content_id"
	
	validates_presence_of :pdf, :thumbnail
	validates_associated :pdf, :thumbnail
	
	def binary_attributes=(binaries)
			pdf_data 		= binaries[:pdf][:uploaded_data]
			thumbnail_data 	= binaries[:thumbnail][:uploaded_data]
		
		if self.new_record?
		
			unless pdf_data.blank?			
				self.build_pdf(:filename 		=> pdf_data.original_filename,
								:content_type 	=> pdf_data.content_type.chomp,
								:binary_data 	=> pdf_data.read,
								:size			=> pdf_data.size)
			end
			unless thumbnail_data.blank?
				self.build_thumbnail(:filename 		=> thumbnail_data.original_filename,
										:content_type 	=> thumbnail_data.content_type.chomp,
										:binary_data 	=> thumbnail_data.read,
										:size			=> thumbnail_data.size)
			end		
		
		else
		
			unless pdf_data.blank?					
				self.pdf.update_attributes(:filename 		=> pdf_data.original_filename,
								:content_type 	=> pdf_data.content_type.chomp,
								:binary_data 	=> pdf_data.read,
								:size			=> pdf_data.size)
			end
			unless thumbnail_data.blank?
				self.thumbnail.update_attributes(:filename 		=> thumbnail_data.original_filename,
										:content_type 	=> thumbnail_data.content_type.chomp,
										:binary_data 	=> thumbnail_data.read,
										:size			=> thumbnail_data.size)
			end		
		
		end
		
	end
	
	def title
		result = super 
		result + " Cheatsheet" if result
	end
end
