class MessagesController < ApplicationController
	
	def create
		puts params[:message]
	end
end
