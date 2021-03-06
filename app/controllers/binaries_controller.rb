class BinariesController < ApplicationController
	
	caches_page :show
	
	def show 
		respond_to do |wants|
			wants.png do
				if @image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],5)
					render(:binary, @image_data => :image)	
				else
					raise ActiveRecord::RecordNotFound, "Record not found"
				end
			end
		end
	end
	
	def grey
		respond_to do |wants|
				wants.png do
				if @image_data = PortfolioItem.find_by_company_id_and_portfolio_type_id(params[:id],6)
					render(:binary, @image_data => :image)
				else
					raise ActiveRecord::RecordNotFound, "Record not found"
				end
			end
		end
	end
end
