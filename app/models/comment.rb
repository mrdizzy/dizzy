# == Schema Information
# Schema version: 4
#
# Table name: comments
#
#  id         :integer(11)   not null, primary key
#  body       :text          
#  subject    :string(255)   
#  email      :string(255)   
#  parent_id  :integer(11)   
#  content_id :integer(11)   
#  created_at :datetime      
#  new        :boolean(1)    default(TRUE)
#  name       :string(255)   
#

class Comment < ActiveRecord::Base
	belongs_to :content
	acts_as_tree :order => :subject
	validates_presence_of :name, :email, :body, :subject, :content_id
	validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "must contain a valid address"
	
	def self.new_comments
		self.find_all_by_new(true, :order => "'created_at' DESC")
	end
	
	def validate
		if parent_id
			if parent.nil?
				errors.add(:parent_id, "must exist in the database")
			end
		end
	end
end
