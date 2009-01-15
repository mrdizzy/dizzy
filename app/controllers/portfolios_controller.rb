class PortfoliosController < ApplicationController
	
	caches_page :show, :index
	
	def index
		@companies = Company.pages(params[:page])
		@company = Company.first
		respond_to do |wants|
			wants.html { render :action => "show"}
			wants.js do
				render :update do |page|
					page.replace_html :portfolio_list, :partial => "company_list"
				end
			end
		end
	end
	
	def show
		@companies = Company.pages(params[:page])
		@company 	= Company.find(params[:id])	
		@header		= PortfolioItem.header.find_by_company_id(@company.id)
    	respond_to do |wants|
    		wants.html
    		wants.js do 
    			render :update do |page|
    				page.replace_html :logos, portfolio_table				
					page.replace_html :company_description, :partial => "company_description"	
				end
			end
		end
	end
	
end
