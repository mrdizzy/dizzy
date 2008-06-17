# == Schema Information
# Schema version: 4
#
# Table name: categories
#
#  id        :integer(11)   not null, primary key
#  name      :string(255)   
#  permalink :string(255)   
#

class Category < ActiveRecord::Base
	has_and_belongs_to_many :contents, :order => "date DESC"
	#has_many :cheatsheets, :through => :categories_contents, :source => "content", :order => "date DESC", :conditions => "contents.type = 'Cheatsheet'"
	validates_presence_of 		:name, :permalink
	validates_uniqueness_of 	:permalink, :name
	validates_format_of			:permalink, :with => /^[a-z0-9-]+$/
end
