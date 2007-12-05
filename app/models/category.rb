# == Schema Information
# Schema version: 34
#
# Table name: categories
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Category < ActiveRecord::Base
	has_many :categories_contents
	has_many :contents, :through => :categories_contents, :order => "date DESC"
	
	has_permalink :name
	
	validates_uniqueness_of :name
	validates_presence_of :name
end