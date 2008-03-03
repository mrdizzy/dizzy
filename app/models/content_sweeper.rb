class ContentSweeper < ActionController::Caching::Sweeper
	
	observe Content
	
	def after_save(record)
		expire_content_page(record)
	end
	
	def after_destroy(record)
		expire_content_page(record)
	end
	
	private
	
	def expire_content_page(record)
		expire_page hash_for_content_path(:category_id => params[:category_id], :id => record.permalink)
		expire_page hash_for_formatted_content_path(:category_id => params[:category_id], :id => record.permalink, :format => :png)
		expire_page hash_for_formatted_content_path(:category_id => params[:category_id], :id => record.permalink, :format => :pdf)	
	end
	
end