# == Schema Information
# Schema version: 4
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
#  version_id  :integer(11)   
#

class Content < ActiveRecord::Base
	has_and_belongs_to_many :categories
	has_and_belongs_to_many :related_articles, :class_name => "Content", :foreign_key => "related_id"
	has_many :comments, :dependent => :destroy, :order => "'created_at' DESC"
	has_many :sections, :dependent => :destroy, :order => "'title' ASC"
	belongs_to :version
	belongs_to :user
	
	validates_presence_of :title, :description, :date, :user_id, :permalink, :version_id 
	validates_uniqueness_of :permalink	
	
	before_save :create_new_version
	
	attr_accessor :new_version
	
	def main_category
		self.categories.first
	end
	
	def create_new_version
		create_version(:version_number => new_version) unless new_version.blank?
	end

	def self.latest
		self.find(:first, :order => "date ASC")	
	end
	
	def self.recent
		self.find(:all, :limit => 10, :order => "date DESC")	
	end
	
end

class Article < Content
	validates_presence_of :content	
	before_save :parse_content	
	
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
	has_one :pdf, :dependent => :destroy, :foreign_key => "content_id"
	has_one :thumbnail, :dependent => :destroy, :foreign_key => "content_id"
	
	def title
		result = super 
		result + " Cheatsheet" if result
	end
end
