class ContentSweeper < ActionController::Caching::Sweeper
	
	observe Content
	
	def after_save(record)
		expire_content_page(record)
		expire_category_page(record)
		expire_welcome_page(record)
	end
	
	private
	
	def expire_content_page(record)
		expire_page hash_for_content_path(:category_id => record.main_category_permalink, :id => record.permalink)
		expire_page hash_for_formatted_content_path(:category_id => record.main_category_permalink, :id => record.permalink, :format => :png)
		
	end
	
	def expire_category_page(record)
		
		record.categories.each do |category|
			expire_fragment(:controller => "categories", :action => "show", :id =>category.permalink)
			expire_fragment(:controller => "categories", :action => "show", :part => "administrator", :id => category.permalink)
		end
	end
	
	def expire_welcome_page(record)
		expire_page(:controller => "welcome", :action => "index")
	end
end