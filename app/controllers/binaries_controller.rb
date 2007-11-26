class BinariesController < ApplicationController
	caches_page :cheatsheet_thumbnail, :portfolio_image,:portfolio_type, :footer_logo, :grey_footer_logo, :get_file, :get_cheatsheet_pdf
	
	cache_sweeper :content_binary_sweeper
	
	def portfolio_image 
		@image_data = PortfolioItem.find(params[:id])
		@image = @image_data.data
		send_data(@image, :type => @image_data.content_type, :disposition => 'inline')
	end
	
	def cheatsheet_thumbnail 
		@image_data = Cheatsheet.find_by_permalink(params[:permalink])
		@image = @image_data.thumbnail
		send_data(@image, :type => "image/png", :disposition => 'inline')
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
	
	def get_file
		@data = Binary.find(params[:id])
		send_data(@data.binary, :type => @data.content_type, :disposition => 'inline')
	end
	
	def get_cheatsheet_pdf
		@pdf_data = Cheatsheet.find_by_permalink(params[:permalink])
		@pdf = @pdf_data.content_binary.binary_data
		send_data(@pdf, :type => "application/pdf", :disposition => 'attachment')		
	end
	
	def get
		@data = Binary.find(params[:id])
		send_data(@data.binary, :type => @data.content_type, :disposition => 'inline')
	end
end
