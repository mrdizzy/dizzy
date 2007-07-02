# == Schema Information
# Schema version: 34
#
# Table name: categories
#
#  id   :integer(11)   not null, primary key
#  name :string(255)   
#

class Category < ActiveRecord::Base
	has_and_belongs_to_many :contents
	
	has_permalink :name
	
	validates_uniqueness_of :name
	validates_presence_of :name
end
