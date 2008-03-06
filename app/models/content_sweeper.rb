class ContentSweeper < ActionController::Caching::Sweeper
	
	observe Content
	
	def after_save(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page(record)
	end
	
	def after_destroy(record)
		expire_content_page(record)
		expire_latest_page(record)
		expire_welcome_page(record)
	end
	
	private
	
	def expire_content_page(record)
		expire_page hash_for_content_path(:id => record.permalink)
		expire_page hash_for_formatted_content_path(:id => record.permalink, :format => :png)
		expire_page hash_for_formatted_content_path(:id => record.permalink, :format => :pdf)	
	end
	
	def expire_latest_page(record)
		expire_page hash_for_latest_path
	end
	
	def expire_welcome_page(record)
		expire_page(:controller => :welcome)
	end
end