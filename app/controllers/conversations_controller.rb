class ConversationsController < ApplicationController
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
		@ticket = Ticket.new
		2.times { @ticket.ticket_collaterals.build }
  	end  
	
	def reply_form
		@conversation = Conversation.find(params[:id])
		
		@ticket = Ticket.new
		2.times { @ticket.ticket_collaterals.build }
		render :update do |page|
			page.insert_html :after, "ticket_#{params[:ticket]}", :partial => "reply_form"
		page.visual_effect :toggle_blind, :reply_form
		end	
	end
	
   	def send_reply 
		@conversation = Conversation.find(params[:id])
		@ticket = OutgoingTicket.new(params[:ticket])
		
		#params[:ticket_collaterals].each_value { |collateral| @ticket.ticket_collaterals.build(collateral) }
	
		@ticket.conversation = @conversation
		@ticket.date = Time.now
		Person.transaction do
		@ticket.save!		
		email = Mercury.deliver_ticket_response(@ticket)
		redirect_to :action => "list"
	end
  end
end
