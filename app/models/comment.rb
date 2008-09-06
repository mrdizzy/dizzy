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
	validates_existence_of :content
	acts_as_tree :order => "subject"
	validates_presence_of :name, :email, :body, :subject, :content_id
	validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "must contain a valid address", :allow_blank => true
	
	def self.new_comments
		self.find_all_by_new(true, :order => "'created_at' DESC")
	end
	
	def validate
		# Check comment has valid parent if it is a child
		if parent_id
			if parent.nil?
				errors.add(:parent_id, "must exist in the database")
			end
		end
		
		# Check comment is linked to a valid article
		if content.nil?
			errors.add(:content_id, "must exist in the database")
		end
		
	end
end
