class ConversationsController < ApplicationController
	
	
	def show 
	
	end
	
	def edit
      
  	end
  	
  	def new
  		@conversation		= Conversation.new
		
		respond_to do |wants|
	 		wants.js
	 	end
  	end

  def update
  
  end  	
	
	def create
	
	end
	
	def destroy
		
	end
end