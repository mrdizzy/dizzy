class MessagesController < ApplicationController
	
	def create
		@message = Message.new(params[:message])
		if @message.save		
			Mercury.deliver_new_message(@message)
			render :update do |page|
				page['contact_form'].toggle
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
