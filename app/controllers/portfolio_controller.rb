class PortfolioController < ApplicationController
	
	def show_ajax		
		@company 	= Company.find(params[:id])
    	@header = PortfolioItem.find_by_portfolio_type_id_and_company_id(7,@company.id)

		render :update do |page|			
				page.replace_html :logos, portfolio_table				
				page.replace_html :company_description, :partial => "company_description"	
		end
	end
	
	def portfolio_list
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name
		render :update do |page|
			page.replace_html :portfolio_list, :partial => "portfolio_list"
		end
	end
	
	def show			
		@company_pages, @companies = paginate :companies, :per_page => 8, :order => :name		
		@company 	= Company.find(params[:id])		
    	@header = PortfolioItem.find_by_portfolio_type_id_and_company_id(7,@company.id)
	end  
end
