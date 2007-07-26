class Conversation < ActiveRecord::Base
	has_many :tickets, :dependent => :destroy, :order => "date DESC" 
	has_many :emails, :through => :tickets, :uniq => true 
	belongs_to :person
	belongs_to :conversation_type
	#has_many :emails, :through => :customer
	
	def parse_code
		"DIZY-#{id}-"
	end
end

class OpenConversation < Conversation
end
class ClosedConversation < Conversation
end
