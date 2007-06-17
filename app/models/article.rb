# == Schema Information
# Schema version: 34
#
# Table name: articles
#
#  id        :integer(11)   not null, primary key
#  title     :string(255)   
#  content   :text          
#  date      :datetime      
#  author_id :integer(11)   
#  excerpt   :text          
#  permalink :string(255)   
#

class Article < ActiveRecord::Base
	has_permalink :title
	has_and_belongs_to_many :categories
	belongs_to :author
	
	validates_presence_of :content, :title, :date, :author_id, :excerpt, :permalink
	validates_uniqueness_of :title, :permalink
end
