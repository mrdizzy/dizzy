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
	def get_children(folder)
		result = "<ul>"
		folder.children.each do |child|
			result = result + "<li>#{child.name}</li>"
			if child.children
				result = result + get_children(child)
			end
		end
		result = result + "</ul>"
	end
	def get_folders
		result = "<ul>"
		Folder.find_all_by_parent_id(nil).each do |folder|
			result = result + "<li>#{folder.name}</li>"
			if folder.children 
				result = result + get_children(folder)
			end
		end
		result = result + "</ul>"
		result
	end
end
