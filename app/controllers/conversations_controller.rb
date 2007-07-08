class ConversationsController < ApplicationController
		before_filter :authorize
	  def index
    list
    render :action => 'list'
  end
	def list
		@open_conversations = Conversation.find_all_by_status("OPEN")
		
		@untagged_conversations = Conversation.find_all_by_status("UNTAGGED")
		
	end
	
	def view_thread
		
	@conversation = Conversation.find(params[:id])
	@ticket = Ticket.new
	2.times { @ticket.ticket_collaterals.build }
  end  
	
  
   	def send_reply 
   		
		@conversation = Conversation.find(params[:id])
		@ticket = OutgoingTicket.new(params[:ticket])
		
		#params[:ticket_collaterals].each_value { |collateral| @ticket.ticket_collaterals.build(collateral) }
	
		@ticket.conversation = @conversation
		@ticket.date = Time.now
		Customer.transaction do
		@ticket.save!		
		email = Mercury.deliver_ticket_response(@ticket)
		render(:text => "<pre>" + email.encoded + "</pre>" )
	end
  	
  end
end
