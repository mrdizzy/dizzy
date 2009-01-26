class MessagesController < ApplicationController
	
	def create
	
		@message = Message.new(params[:message])
		@message.recaptcha_challenge_field = params[:recaptcha_challenge_field]
		@message.remote_ip = request.remote_ip
			
		if @message.save
			Mercury.deliver_new_message(@message)
			@message = Message.new
			render :update do |page|
				page['contact_form'].toggle
				page['contact_form'].replace_html :partial => "shared/contact_form"
			end
		else
			render :update do |page|
				page['contact_form'].replace_html :partial => "shared/contact_form"
			end
		end
	end
	
	def index
		@messages = Message.all
	end
end
