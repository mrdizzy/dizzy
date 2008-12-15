class ContentSweeper < ActionController::Caching::Sweeper
	
	# TODO Make sweeper regenerate content pages upon category modification
	# TODO Make sweeper regenerate PDF after new PDF uploaded
	
	observe Content
	
	def after_save(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page
		expire_rss_feed
		expire_cheatsheets_index
	end
	
	def after_destroy(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page
		expire_rss_feed
		expire_cheatsheets_index
	end
	
	private
	
	def expire_content_page(record)
		
		if record.is_a?(Cheatsheet)			
			expire_page hash_for_cheatsheet_path(:id => record.permalink)
			expire_page hash_for_formatted_cheatsheet_path(:id => record.permalink, :format => :png)
			expire_page hash_for_formatted_cheatsheet_path(:id => record.permalink, :format => :pdf)	
		else		
			expire_page hash_for_content_path(:id => record.permalink)
		end
	end
	
	def expire_latest_page(record)
		expire_page hash_for_latest_path
		expire_page "/ruby_on_rails/cheatsheets"
	end
	
	def expire_rss_feed
		expire_page "/ruby_on_rails/contents.rss"
	end
	
	def expire_welcome_page
		expire_page(:controller => :welcome)
	end
end