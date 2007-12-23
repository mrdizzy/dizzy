# == Schema Information
# Schema version: 6
#
# Table name: conversations
#
#  id      :integer(11)   not null, primary key
#  subject :string(255)   
#  type    :string(255)   
#

class Conversation < ActiveRecord::Base

	has_many :tickets, :dependent => :destroy, :order => "date DESC" 
	has_many :emails, :through => :tickets, :uniq => true 
	has_and_belongs_to_many :people

	
	def parse_code
		"DIZY-#{id}-"
	end
end

class OpenConversation < Conversation
end
class ClosedConversation < Conversation
end
