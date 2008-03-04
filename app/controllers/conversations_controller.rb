class ConversationsController < ApplicationController
  	
  	def new
  		@conversation		= Conversation.new
		
		respond_to do |wants|
	 		wants.js
	 	end
  	end

	def create
		if Conversation.create(params[:conversation])
			respond_to do |wants|
				wants.js			
			end			
		end		
	end
	
end