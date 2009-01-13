class WelcomeController < ApplicationController
	
	caches_page :index
	helper :portfolios
	
	def index
		@companies = Company.find(:all, :order => 'RAND()', :limit => 6)
		@articles 			= Content.recent.all(:limit => 12)

		
	end	
	
	def show
		
		@logos = PortfolioItem.paginate :per_page => 1, :page => params[:page], :conditions => [ "portfolio_type_id = ?", 4]
		
		respond_to do |wants|
			wants.html
			wants.js do
				render :update do |page|
					page.visual_effect :fade, :latest_logo
					page.delay(4) do
						page.replace_html :latest_logo, :partial => "latest_logo"
						page.visual_effect :appear, :latest_logo
					end			
					page.replace_html :logo_pagination, :partial => "logo_pagination"
				end
			end
		end
	
	end
end
