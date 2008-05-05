class PortfolioItemsController < ApplicationController
	
	def show
		@portfolio_item = PortfolioItem.find(params[:id])
		respond_to do |wants|
			wants.png { send_data(@portfolio_item.data, :type => @portfolio_item.content_type, :disposition => 'inline') }
		end
	end
	
end
