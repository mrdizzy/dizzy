class SectionSweeper < ActionController::Caching::Sweeper
	
	observe Section
	
	def after_save(record)
		expire_content_page(record)
		expire_section_page(record)
	end
	
	private
	
	def expire_content_page(record)
		expire_page hash_for_content_path(:category_id => record.main_category.permalink, :id => record.permalink)
		expire_page hash_for_formatted_content_path(:category_id => record.main_category.permalink, :id => record.permalink, :format => :png)
		expire_page hash_for_formatted_content_path(:category_id => record.main_category.permalink, :id => record.permalink, :format => :pdf)		
	end
	
end