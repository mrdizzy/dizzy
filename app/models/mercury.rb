require 'net/imap'
class Mercury < ActionMailer::Base
		require_dependency 'ticket'	
		require_dependency 'conversation'
		require_dependency 'recipient'
	
  	def ticket_response(ticket)
	    subject     "#{ticket.conversation.subject} #{ticket.conversation.parse_code}"
	    body(:ticket => ticket)
	    addys = ticket.to_recipients.collect { |recipient| recipient.email.email }
	    recipients  addys
	    from        'casamiento@dizzy.co.uk'
	    sent_on    ticket.date
	    
	   	ticket.ticket_collaterals.each do |collateral|
				
		attachment :content_type => collateral.content_type,
					:body => collateral.body,
					:filename => collateral.name
		end
	end
  
	def receive(email)
		ticket = IncomingTicket.new	
		ticket.initial_report = email.body
		ticket.date = email.date
		# Save attachments 
		if email.has_attachments?
			email.attachments.each do |attachment|
				collateral = TicketCollateral.new(
								:name => attachment.original_filename,
								:body => attachment.read,
								:content_type => attachment.content_type)
				ticket.ticket_collaterals << collateral
			end
		end
	
		# Existing conversation thread		
		if email.subject =~ /DIZY-([0-9]{1,6})-/
			conversation = Conversation.find($1)			
			conversation[:type] = 'OpenConversation' 
			
		# New conversation thread
		else
			conversation = OpenConversation.new
			conversation.subject = email.subject	
		end
			email.from.each do |from|
				email_addy = Email.find_by_email(from)
				if email_addy.nil?
					new_email = Email.new(:email => from)
					person = Person.new(:firstname => "Boo")
					new_email.person = person
					conversation.people << person
					ticket.from_recipients.build(:email => new_email)
				else
					from_recipient =  FromRecipient.new
					from_recipient.email = email_addy					
					ticket.from_recipients << from_recipient
				end
			end
			unless email.cc.nil?
				email.cc.each do |cc| 
					email_addy = Email.find_by_email(cc)
					if email_addy.nil?
						new_email = Email.new(:email => cc)
						person = Person.new(:firstname => "Boo2")
						new_email.person = person
						conversation.people << person
						ticket.cc_recipients.build(:email => new_email)
					else
						cc_recipient =  CcRecipient.new
						cc_recipient.email = email_addy					
						ticket.cc_recipients << cc_recipient
					end
				end
			end	
			
			email.to.each do |to|
				email_addy = Email.find_by_email(to)
				if email_addy.nil?
					new_email = Email.new(:email => to)
					person = Person.new(:firstname => "Boo3")
					new_email.person = person
					conversation.people << person
					ticket.to_recipients.build(:email => new_email)
				else
					to_recipient =  ToRecipient.new
					to_recipient.email = email_addy					
					ticket.to_recipients << to_recipient
				end
			end
			conversation.tickets << ticket
			conversation.save
	end
	
	def self.check_mail
	    imap = Net::IMAP.new('www21.a2hosting.com')
	    imap.authenticate('LOGIN', 'casamiento@dizzy.co.uk', 'world1')
	    imap.select('INBOX')
	    imap.search(['ALL']).each do |message_id|
		    msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
		    Mercury.receive(msg)
		    #Mark message as deleted and it will be removed from storage when session closed
		    imap.store(message_id, "+FLAGS", [:Deleted])
	    end
	   	imap.expunge
	end
end
