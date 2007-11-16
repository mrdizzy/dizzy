class PollsController < ApplicationController
	
	def index 
		@poll = Poll.find(:first, :order => "'id' desc")
	end
		
	def vote 
		@vote = Vote.find(params[:result])
		@poll = @vote.poll
		@vote.increment!(:total)
		render :update do |page|
			page.replace_html :poll, :partial => "poll_results"		
		end
	end	
end
