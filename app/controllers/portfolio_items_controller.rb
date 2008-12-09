class PortfolioItemsController < ApplicationController
	
	before_filter :authorize, :except => :show 
	
	def show
		@portfolio_item = PortfolioItem.find(params[:id])
		respond_to do |wants|
			wants.png { send_data(@portfolio_item.data, :type => @portfolio_item.content_type, :disposition => 'inline') }
		end
	end
	
	def edit
		@designs			= PortfolioType.find(:all, :order => :description)
		@portfolio_item		= PortfolioItem.find(params[:id])
		render :update do |page|
			page.insert_html :after, "portfolio_item_#{@portfolio_item.id}", :partial => 'edit', :locals => { :portfolio_item => @portfolio_item, :designs => @designs }
		end
	end
	
	def new
		@designs		= PortfolioType.find(:all, :order => :description)
		@portfolio_item = PortfolioItem.new
		render :update do |page|
			page.insert_html :bottom, "new_items", :partial => 'new', :locals => { :portfolio_item => @portfolio_item, :designs => @designs, :index => params[:index] }
			page.replace :add_extra_link, :partial => 'new_link', :locals => { :index => (params[:index].to_i + 1) }  
		end
	end
	
	def destroy
		@portfolio_item		= PortfolioItem.find(params[:id])
		@portfolio_item.destroy
		render :update do |page|			
			page.visual_effect(:fade, "portfolio_item_container_#{params[:id]}")			
		end
	end
end
