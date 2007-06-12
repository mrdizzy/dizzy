# == Schema Information
# Schema version: 19
#
# Table name: authors
#
#  id        :integer(11)   not null, primary key
#  username  :string(255)   
#  firstname :string(255)   
#  surname   :string(255)   
#  email     :string(255)   
#

class Author < ActiveRecord::Base
	has_many :articles
	has_many :cheatsheets
	
	validates_presence_of :firstname, :surname, :email, :username
	validates_uniqueness_of :username, :email
end
