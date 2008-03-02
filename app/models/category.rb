# == Schema Information
# Schema version: 6
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
	validates_presence_of :name, :permalink
	validates_uniqueness_of :permalink, :name
end
