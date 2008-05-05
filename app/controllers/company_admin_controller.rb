class CompanyAdminController < ApplicationController
		
	cache_sweeper :portfolio_item_sweeper
		
	def index
		@companies = Company.find(:all)
	end  
	  
	def show
		@company = Company.find(params[:id])
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
		
		params[:portfolio_items].each_value do |item| 
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
 			redirect_to :action => 'edit', :id => @company  
		else    
			@designs = PortfolioType.find(:all)
			render :action => 'edit'  
		end 	 
 	end

	def destroy
		Company.find(params[:id]).destroy
	    redirect_to :action => 'list'
	end

	
	def remove_item
		render :update do |page|
			page["portfolio_item_#{params[:index]}"].remove 
		end
	end
  
	def add_item  
		@designs		= PortfolioType.find(:all, :order => :description)
		@portfolio_item = PortfolioItem.new	
		render :update do |page|
			page.insert_html :bottom, :items, :partial => 'item_fields', :locals => { :item => @portfolio_item, :index => params[:index], :designs => @designs }
page.replace :add_item_link, :partial => 'add_item_link', :locals => { :index => (params[:index].to_i + 1) }  
		end
	end
	
	def edit_image
		@designs			= PortfolioType.find(:all, :order => :description)
		@portfolio_item		= PortfolioItem.find(params[:id])
		render :update do |page|
			page.insert_html :after, "portfolio_item_#{@portfolio_item.id}", :partial => 'mini_edit', :locals => { :portfolio_item => @portfolio_item, :designs => @designs }
		end
	end

	def delete_image
		@portfolio_item		= PortfolioItem.find(params[:id])
		@portfolio_item.destroy
		render :update do |page|			
			page.visual_effect(:fade, "portfolio_item_container_#{params[:id]}")			
		end
	end	
	
	def add_extra
		@designs		= PortfolioType.find(:all, :order => :description)
		@portfolio_item = PortfolioItem.new
		render :update do |page|
			page.insert_html :bottom, "new_items", :partial => 'add_extra', :locals => { :portfolio_item => @portfolio_item, :designs => @designs, :index => params[:index] }
			page.replace :add_extra_link, :partial => 'add_extra_link', :locals => { :index => (params[:index].to_i + 1) }  
		end
	end
	 
 
end