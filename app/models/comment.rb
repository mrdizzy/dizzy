# == Schema Information
# Schema version: 20081208231312
#
# Table name: comments
#
#  id         :integer(4)    not null, primary key
#  body       :text          
#  subject    :string(255)   
#  email      :string(255)   
#  parent_id  :integer(4)    
#  content_id :integer(4)    default(0), not null
#  created_at :datetime      
#  new        :boolean(1)    default(TRUE)
#  name       :string(255)   
#

class Comment < ActiveRecord::Base
	belongs_to :content
	acts_as_tree :order => "subject"
	
	validates_existence_of :content, :parent, :allow_nil => true
	validates_presence_of :name, :email, :body, :subject, :content_id
	validates_format_of :email, :with => /^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i, :message => "must contain a valid address", :allow_blank => true
	
	named_scope :new_comments, :conditions => { :new => true }, :order => "created_at DESC"

end
