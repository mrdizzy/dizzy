class BinariesController < ApplicationController
	caches_page :footer_logo, :grey_footer_logo
	
	def footer_logo
		@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],6)
		@image = @image_data.data
		send_data(@image, :type => @image_data.content_type, :disposition => 'inline')		
	end
	
	def grey_footer_logo
		@image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],5)
		@image = @image_data.data
		send_data(@image, :type => @image_data.content_type, :disposition => 'inline')	
	end
	
end
