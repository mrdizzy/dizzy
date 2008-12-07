class WelcomeController < ApplicationController
	
	def index
		paginate_logos
		@recent 			= Content.recent(:limit => 5, :conditions => [ "style != ?", "SNIPPET" ] )
		@main_article		= @articles.shift
		@snippets			= Content.recent.snippets.all(:limit => 3)
	end
	
	def next_logo
		paginate_logos
		render :update do |page|
			page.visual_effect :fade, :latest_logo
			page.delay(4) do
				page.replace_html :latest_logo, :partial => "latest_logo"
				page.visual_effect :appear, :latest_logo
			end			
			page.replace_html :logo_pagination, :partial => "logo_pagination"
		end
	end	
	
	private
	
	def paginate_logos
		@logo_pages, @logos = paginate :portfolio_items, :per_page => 1, :include => [:portfolio_type, :company], :conditions => ["portfolio_types.description = ? AND companies.visible = ?", "Logo", 1], :order => "portfolio_items.id desc"
	end
end
