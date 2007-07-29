class ConversationsController < ApplicationController
	require_dependency 'recipient'
	require_dependency 'ticket'
	before_filter :authorize
		
	def index
	    list
	    render :action => 'list'
  	end
  	
	def list
		@open_conversations = OpenConversation.find(:all)
	end
	
	def view_thread		
		@conversation = Conversation.find(params[:id])
  	end  
  	
  	def view_ticket 
  		@ticket = Ticket.find(params[:id])
  		render :update do |page|
			page.replace_html "details_#{params[:id]}", :partial => "view_ticket"
		end	
  	end
  	
  	def add_attachment
  		render :update do |page|
			page.insert_html :after, "add_attachment", :partial => "add_attachment"
		end			
  	end
	
	def reply_form
		@ticket = Ticket.find(params[:id])
		@conversation = @ticket.conversation.id
		
		@to_recipients = @ticket.to_recipients.collect { |recipient| [recipient.email.email, recipient.email_id]} + @ticket.from_recipients.collect { |recipient| [recipient.email.email, recipient.email_id]}
		@cc_recipients = @ticket.cc_recipients.collect { |recipient| [recipient.email.email, recipient.email_id]}
		
		@ticket = Ticket.new
		2.times { @ticket.ticket_collaterals.build }
		render :update do |page|
			page.insert_html :after, "ticket_#{params[:id]}", :partial => "reply_form"
		page.visual_effect :toggle_blind, :reply_form
		end	
	end
	
   	def send_reply 

		@conversation = Conversation.find(params[:id])
		@ticket = OutgoingTicket.new(params[:ticket])
	
		params[:data_file].each do |collateral|
   			@ticket.ticket_collaterals.build(:data_file => collateral)
   		end
		@ticket.conversation = @conversation
		@ticket.date = Time.now
		@ticket.save!
			
		email = Mercury.deliver_ticket_response(@ticket)
		redirect_to :action => "list"
	end

end
