class PortfolioController < ApplicationController
	
	def show_ajax		
		@company 	= Company.find(params[:id])
    	@header = PortfolioItem.find_by_portfolio_type_id_and_company_id(7,@company.id)
    	@portfolio_item = PortfolioItem.find_all_by_company_id(	@company.id, 
    															:include => :portfolio_type, 
    															:order => "portfolio_types.position,portfolio_types.column_space", 
    															:conditions => "portfolio_types.visible = 1" )
		column_total 	= 0 
		counter 		= 0 
		@newrow 		= []
		for item in @portfolio_item
		  	@newrow.push(item)
    		column_total = item.portfolio_type.column_space + column_total 
			if column_total > 3 
				result = column_total - 3 
 				column_total = (item.portfolio_type.column_space - result) 
 				@portfolio_item[(counter-1)].portfolio_type.column_space = (@portfolio_item[(counter-1)].portfolio_type.column_space + result) 
 				column_total = 0
  			end 
  			if column_total == 3 
  				column_total = 0 
   			end 
    		counter = counter + 1 
    	end   

		render :update do |page|			
				page.replace_html :logos, :partial => "portfolio_table"		
				
				page.replace_html :company_description, :partial => "company_description"	
		end
	end
	
	def portfolio_list
		@company_pages, @companies = paginate :companies, :per_page => 2, :order => :name
		render :update do |page|
			page.replace_html :portfolio_list, :partial => "portfolio_list"
		end
	end
	
	def show			
		@company_pages, @companies = paginate :companies, :per_page => 2, :order => :name
		if (params[:id]) 
			@company 	= Company.find(params[:id])
		else
			@company	= Company.find(:first)
		end
    	@header = PortfolioItem.find_by_portfolio_type_id_and_company_id(7,@company.id)
    	@portfolio_item = PortfolioItem.find_all_by_company_id(	@company.id, 
    			:include => :portfolio_type,    															:order => "portfolio_types.position,portfolio_types.column_space", 
    			:conditions => "portfolio_types.visible = 1" )
    	
		column_total 	= 0 
		counter 		= 0 
		@newrow 		= []
		@portfolio_item.each do |item|
		  	@newrow.push(item)
    		column_total = item.portfolio_type.column_space + column_total 
			if column_total > 3 
				result = column_total - 3 
 				column_total = (item.portfolio_type.column_space - result) 
 				@portfolio_item[(counter-1)].portfolio_type.column_space = (@portfolio_item[(counter-1)].portfolio_type.column_space + result) 
 				column_total = 0
  			end 
  			if column_total == 3 
  				column_total = 0 
   			end 
    		counter = counter + 1 
    	end   
	end  

end
