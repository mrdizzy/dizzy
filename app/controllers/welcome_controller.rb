class WelcomeController < ApplicationController

	def index
		paginate_logos
		@recent_articles 	= Article.recent
		@main_article 		= @recent_articles.shift
		@poll 				= Poll.find(:first, :order => "'id' desc")
		@cheatsheet 		= Cheatsheet.latest
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
	
	def contact 
		render :update do |page|
			page.insert_html :after, :navigation, :partial => "contact"
			page.visual_effect :toggle_blind, :contact_form
			page.replace_html :contact_us, "<b>Contact us</b>"
		end
	end
	
	private
	
	def paginate_logos
		@logo_pages, @logos = paginate :portfolio_items, :per_page => 1,:include => :portfolio_type, :conditions => ["portfolio_types.description = ?", "Logo"], :order => "portfolio_items.id desc"
	end
end
