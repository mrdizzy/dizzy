class MessagesController < ApplicationController
	
	def create
		@message = Message.new(params[:message])
		@message.save		
		Mercury.deliver_new_message(@message)
	end
	
	def index
		@messages = Message.all
	end
end
