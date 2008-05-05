class PortfoliosController < ApplicationController
	
	def index
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name
		respond_to do |wants|
			wants.html
			wants.js
		end
	end
	
	def show			
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name		
		@company 	= Company.find(params[:id])		
    	@header 	= PortfolioItem.find_by_portfolio_type_id_and_company_id(7,@company.id)
    	
    	respond_to do |wants|
    		wants.html
    		wants.js
    	end
	end  
end
