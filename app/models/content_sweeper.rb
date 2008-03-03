class ContentSweeper < ActionController::Caching::Sweeper
	
	observe Content
	
	def after_save(record)
		expire_content_page(record)
	end
	
	private
	
	def expire_content_page(record)
		expire_page hash_for_content_path(:category_id => record.main_category_permalink, :id => record.permalink)
		expire_page hash_for_formatted_content_path(:category_id => record.main_category_permalink, :id => record.permalink, :format => :png)
		
	end
	
end