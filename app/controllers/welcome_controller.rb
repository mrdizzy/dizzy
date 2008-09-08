class WelcomeController < ApplicationController
	helper :contents
	
	def index
		# TODO Polymorphic URL: linking to cheatsheet/content
		
		paginate_logos
		@recent_tutorials 	= Cheatsheet.recent
		@recent_snippets	= Content.recent.snippets
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
		@logo_pages, @logos = paginate :portfolio_items, :per_page => 1, :include => [:portfolio_type, :company], :conditions => ["portfolio_types.description = ? AND companies.visible = ?", "Logo", 1], :order => "portfolio_items.id desc"
	end
end
