require 'net/imap'
class Mercury < ActionMailer::Base
		require_dependency 'customer'	
		require_dependency 'ticket'	
	
  	def ticket_response(ticket)
	    subject     "#{ticket.conversation.subject} #{ticket.conversation.parse_code}"
	    body(:ticket => ticket)
	    addys = ticket.conversation.customer.emails.map { |addy| addy.email }
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
		from_email = email.from[0]	
				
		email_addy = Email.find_by_email(from_email)
		
		# Get existing thread identifier
		if email.subject =~ /DIZY-([0-9]{1,6})-/
			conversation = Conversation.find($1)
			
			conversation.status = 'OPEN'
			unless email_addy.nil?
				ticket.email = email_addy
			else
				new_email = ticket.build_email(:email => from_email)
				conversation.customer.emails << new_email
			end
		
		# Start new thread
		else
			conversation = Conversation.new
			conversation.subject = email.subject			
			
			#### No existing email in database	
			if email_addy.nil?
				conversation.status = 'UNTAGGED'
				ticket.build_email( :email => from_email )
							
				conversation.build_customer(:firstname => email.friendly_from)
				ticket.email.customer = conversation.customer
				
			# Existing email but no customer
			elsif !email_addy.nil? and email_addy.customer.nil?
				conversation.status = 'UNTAGGED'
				ticket.email = email_addy	
				
			# Existing email and customer					
			else 				
				conversation.status = 'OPEN'
				conversation.customer = email_addy.customer
				ticket.email = email_addy
			end
		end		
		conversation.tickets << ticket		
		conversation.save!	
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
