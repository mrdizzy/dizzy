class BinariesController < ApplicationController
	caches_page :cheatsheet_thumbnail, :portfolio_image,:portfolio_type, :footer_logo, :grey_footer_logo, :get_file, :get_cheatsheet_pdf
	
	def portfolio_image 
		@image_data = PortfolioItem.find(params[:id])
		@image = @image_data.data
		send_data(@image, :type => @image_data.content_type, :disposition => 'inline')
	end
		
	def portfolio_type 
		@image_data = PortfolioType.find(params[:id])
		@image = @image_data.header_binary
		send_data(@image, :type => @image_data.header_content_type, :disposition => 'inline')		
	end
		
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

	def thumbnail
		content = Content.find_by_permalink(params[:permalink])
		get(content.thumbnail.id)
	end
	
	def pdf 
		content = Content.find_by_permalink(params[:permalink])
		get(content.pdf.id)
	end
	def get(id)
		binary = Binary.find(id)
		send_data(binary.binary_data, :type => binary.content_type, :disposition => 'inline')		
	end
end
