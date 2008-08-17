class BinariesController < ApplicationController
	
	def show 
		respond_to do |wants|
			wants.grey do
				@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],6)
				@image = @image_data.data
				send_data(@image, :type => @image_data.content_type, :disposition => 'inline')	
			end
			wants.png do
				@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],5)
				@image = @image_data.data
				send_data(@image, :type => @image_data.content_type, :disposition => 'inline')	
			end
		end
	end
	
end
