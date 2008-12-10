class PortfoliosController < ApplicationController
	
	caches_page :show, :index
	
	def index
		@companies = Company.paginate :per_page => 8, :order => :name, :page => params[:page], :renderer => 'RemoteLinkRenderer' 
	end
	
	def show			
		@companies = Company.paginate :per_page => 8, :order => :name, :page => params[:page], :renderer => 'RemoteLinkRenderer' 
		@company 	= Company.find(params[:id])		
    	@header 	= @company.portfolio_items.header
	end  
end
