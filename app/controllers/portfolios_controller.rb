class PortfoliosController < ApplicationController
	
	caches_page :show, :index
	
	def index
		@companies = Company.paginate :per_page => 4, :order => :name, :page => params[:page]
		@company = Company.first
		respond_to do |wants|
			wants.html { render :template => "portfolios/show"}
			wants.js
		end
	end
	
	def show			
		@companies = Company.paginate :per_page => 4, :order => :name, :page => params[:page]
		@company 	= Company.find(params[:id])		
    	@header 	= @company.portfolio_items.header
	end  
end
