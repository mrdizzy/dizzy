class PortfolioItemsController < ApplicationController
	
	before_filter 	:authorize, :except => :show 
	
	cache_sweeper 	:portfolio_item_sweeper, :only => [ :destroy, :update, :create ]
	caches_page 	:show
	
	def show
		@portfolio_item = PortfolioItem.find(params[:id])
		respond_to do |wants|
			wants.png { send_data(@portfolio_item.data, :type => "image/png", :disposition => 'inline') }
		end
	end
	
	def edit
		portfolio_item		= PortfolioItem.find(params[:id])
		render :update do |page|
			page[portfolio_item].insert render(:partial => 'edit', :object => portfolio_item), :bottom
		end
	end
	
	def new
		render :update do |page|
			page.insert_html :top, "new_items", :partial => 'edit', :object => PortfolioItem.new
		end
	end
	
	def destroy
		@portfolio_item		= PortfolioItem.find(params[:id])
		if @portfolio_item.destroy
			render :update do |page|			
				page.visual_effect :fade, "portfolio_item_container_#{params[:id]}"			
			end
		end
	end
end
