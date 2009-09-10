class MessagesController < ApplicationController

	before_filter :authorize, :except => [:create, :new]
	
	def new
	  @message = Message.new
	end
	
	def create
		@message = Message.new(params[:message])
		
		if @message.save 
			redirect_to welcome_path
		else
			render :new
		end
	end
	
	def index
		@messages = Message.all
	end

	def destroy_all
		Message.delete_all
		redirect_to messages_path
	end
	
end
