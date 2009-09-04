class MessagesController < ApplicationController

	before_filter :authorize, :except => [:create, :new]
	
	def create
	
		@message = Message.new(params[:message])
		@message.recaptcha_challenge_field = params[:recaptcha_challenge_field]
		@message.remote_ip = request.remote_ip
		
		respond_to do |format|
		
			format.html do
				if @message.save 
					redirect_to "/" 
				else
					render :new
				end
			end
			
			format.js do
				render :update do |page|
					if @message.save
						page.hide "contact_form"			
					else				
						page.replace_html "contact_form", :partial => "shared/contact_form"						
					end
				end
			end
			
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
