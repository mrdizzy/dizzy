class CompaniesController < ApplicationController
		
	cache_sweeper :portfolio_item_sweeper, :company_sweeper
	
	before_filter :authorize
		
	def index
		@companies = Company.find(:all, :order => :name)
	end  
	
  	def edit
  		@company = Company.find(params[:id] )
   		@designs = PortfolioType.find(:all, :order => :description)
   	end	

 	def new
    	@company 	= Company.new
    	@designs	= PortfolioType.find(:all, :order => :description)
    	@company.portfolio_items.build
  	end

	def create    
	  	@designs	= PortfolioType.find(:all)
		@company 	= Company.new(params[:company])   		
		
		if @company.save		
			redirect_to companies_path 	  			
	  	else
	  		render :action => 'new' 
	  	end
	end

	def update
		@company = Company.find(params[:id])
		@company.attributes = params[:company]
	
      if @company.valid? && @company.portfolio_items.all?(&:valid?)  
         @company.save!
         @company.portfolio_items.each(&:save!) 
         redirect_to companies_path
      else    
         @designs = PortfolioType.find(:all)
         render :action => 'edit'  
      end 	 
 	end

	def destroy
		@company = Company.find(params[:id])
		@company.destroy
	end
	
end