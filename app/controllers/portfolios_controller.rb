class PortfoliosController < ApplicationController
	
	caches_page :show, :index
	
	def index
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name
	end
	
	def show			
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name		
		@company 	= Company.find(params[:id])		
    	@header 	= @company.portfolio_items.header
	end  
end
