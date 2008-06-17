# == Schema Information
# Schema version: 4
#
# Table name: conversations
#
#  id         :integer(11)   not null, primary key
#  subject    :string(255)   
#  name       :string(255)   
#  created_at :datetime      
#  email      :string(255)   
#  body       :text          
#

class Conversation < ActiveRecord::Base
	
	validates_presence_of :email, :name, :subject, :body
	
end
