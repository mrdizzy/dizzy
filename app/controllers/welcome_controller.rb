class WelcomeController < ApplicationController
	
	caches_page :index
	
	def index
		@logos = PortfolioItem.paginate :per_page => 1, :page => params[:page], :conditions => [ "portfolio_type_id = ?", 4]
		
		@articles 			= Content.recent.all(:limit => 4, :conditions => [ "contents.style != ? OR contents.style IS NULL", "SNIPPET" ] )
		@main_article		= @articles.shift
		@snippets			= Content.recent.snippets.all(:limit => 3)
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
	
	private
	
end
