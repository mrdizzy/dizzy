module ConversationsHelper
	
	def format_recipient(recipient)
		" " + diamond + " " + (link_to recipient.email.person.firstname, {:controller => :people, :action => :show, :id => recipient.email.person.id })  + " &lt;" + recipient.email.email + "&gt;"
	end
	
	def to_recipients(ticket)
		result = String.new
		ticket.to_recipients.each do |recipient|
				result = result + format_recipient(recipient)
		end
		result
	end

	def from_recipients(ticket)
		result = String.new
		ticket.from_recipients.each do |recipient|
				result = result + format_recipient(recipient)
		end
		result
	end
	def cc_recipients(ticket)
		result = String.new
		ticket.cc_recipients.each do |recipient|
				result = result + format_recipient(recipient)
		end
		result
	end
end
