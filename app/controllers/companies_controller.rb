class CompaniesController < ApplicationController
		
	cache_sweeper :portfolio_item_sweeper
		
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
		
		params[:new_portfolio_items].each_value do |item| 
		  	unless item[:uploaded_data].blank?
		  		@company.portfolio_items.build(item) 
		  	end
		end 	  		
		
		if @company.save		
			redirect_to :action => 'index'  	  			
	  	else
	  		render :action => 'new' 
	  	end
	end

	def update
		@company = Company.find(params[:id])
		@company.attributes = params[:company]
		unless params[:portfolio_items].nil?
			@company.portfolio_items.each do |item| 
				if params[:portfolio_items][item.id.to_s] && !params[:portfolio_items][item.id.to_s][:uploaded_data].blank?
					item.attributes = params[:portfolio_items][item.id.to_s]  
				end
			end
		end
		unless params[:new_portfolio_items].blank?
			params[:new_portfolio_items].each_value do |item| 
			  	unless item[:uploaded_data].blank?
			  		@company.portfolio_items.build(item)
			  	end
			end 	  
		end
		
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