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
	validates_presence_of 	:categories
	validates_format_of		:permalink, :with => /^[a-z0-9-]+$/, :allow_blank => true
	validates_presence_of 	:title, :description, :date, :user_id, :permalink, :version_id 
	validates_uniqueness_of :permalink	

	named_scope :recent, lambda { { :conditions => ["date < ?", 1.hour.ago], :order => "date DESC"  } }
	named_scope :snippets, :conditions => { :style => "SNIPPET" }, :limit => 10, :order => "date DESC"
 	named_scope :tutorials, :conditions => { :style => "TUTORIAL"}, :limit => 10, :order => "date DESC"
  
	before_save :create_new_version
	
	attr_accessor :new_version
	
	def main_category
		self.categories.first
	end
	
	def create_new_version
		create_version(:version_number => new_version) unless new_version.blank?
	end
	
end

class Article < Content
	validates_presence_of 	:content	
	before_save 			:parse_content
	validates_presence_of	:style
	validates_inclusion_of 	:style, :in => STYLES, :allow_blank => true
	
	def parse_content
		self.content.gsub!("<%", "&lt;%")
		self.content.gsub!("%>", "%&gt;")
		self.content
	end
	
	def parsed_content
		self.content.gsub!("&lt;%","<%")
		self.content.gsub!("%&gt;","%>")
		self.content
	end
end

class Cheatsheet < Content
	
	has_many 				:sections, :dependent => :destroy, :order => "'title' ASC", :foreign_key => "content_id"
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
