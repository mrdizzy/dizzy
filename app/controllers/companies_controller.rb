class CompaniesController < ApplicationController
		
	cache_sweeper :portfolio_item_sweeper, :company_sweeper
	before_filter :authorize
		
	def index
		@companies = Company.all
	end  
	
  	def edit
  		@company = Company.find(params[:id])
   	end	

 	def new
    	@company 	= Company.new
    	@company.portfolio_items.build
		render :edit
  	end

	def create    
		@company 	= Company.new(params[:company])   	
		if @company.save
			redirect_to companies_path 	  			
	  	else
	  		render :edit
	  	end
	end

	def update
		@company = Company.find(params[:id])

      if @company.update_attributes(params[:company])   
         redirect_to companies_path
      else    
         render :edit
      end 	 
 	end

	def destroy
		company = Company.find(params[:id])
		if company.destroy
			render :update do |page|
				page.remove "company_#{company.id}" 
			end
		end
	end
	
end