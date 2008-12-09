class BinariesController < ApplicationController
	
	caches_page :show
	
	def show 
		respond_to do |wants|
			wants.grey do
				@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],6)
				send_data(@image_data.data, :type => @image_data.content_type, :disposition => 'inline')	
			end
			wants.png do
				@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],5)
				send_data(@image_data.data, :type => @image_data.content_type, :disposition => 'inline')	
			end
		end
	end
	
end
