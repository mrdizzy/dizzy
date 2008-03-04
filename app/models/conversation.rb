class Conversation < ActiveRecord::Base
	
	validates_presence_of :email, :name, :subject, :body
	
end
