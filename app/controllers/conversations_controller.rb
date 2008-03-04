class ConversationsController < ApplicationController
  	
  	def new
  		@conversation		= Conversation.new
		
		respond_to do |wants|
	 		wants.js
	 	end
  	end

	def create
		@conversation = Conversation.new(params[:conversation])
		if @conversation.save
			respond_to do |wants|
				wants.js			
			end
		else
			respond_to do |wants|
				wants.js { render :action => "new.rjs"}
			end		
		end		
	end
	
end