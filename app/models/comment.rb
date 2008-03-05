# == Schema Information
# Schema version: 6
#
# Table name: comments
#
#  id         :integer(11)   not null, primary key
#  body       :string(255)   
#  subject    :string(255)   
#  email      :string(255)   
#  parent_id  :integer(11)   
#  content_id :integer(11)   
#  created_at :datetime      
#

class Comment < ActiveRecord::Base
	belongs_to :content
	acts_as_tree :order => :subject
	validates_presence_of :name, :email, :body, :subject
	
	def self.new_comments
		self.find_all_by_new(true)
	end
end
