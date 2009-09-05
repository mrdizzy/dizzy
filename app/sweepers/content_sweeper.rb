class ContentSweeper < ActionController::Caching::Sweeper
	
	# TODO Make sweeper regenerate content pages upon category modification
	
	observe Content
	
	def after_save(record)
		record.permalink_was ? expire_content_page(record, record.permalink_was) : expire_content_page(record,record.permalink)
		expire_welcome_page
	end
	
	def after_destroy(record)
		expire_content_page(record, record.permalink)
		expire_welcome_page
	end
	
	private
	
	def expire_content_page(record,permalink)
		if record.is_a?(Cheatsheet)			
			expire_page hash_for_cheatsheet_path(:id => permalink)
			expire_page hash_for_formatted_cheatsheet_path(:id => permalink, :format => :pdf)	
		else		
			expire_page hash_for_content_path(:id => permalink)
		end
	end
	
	def expire_welcome_page
		expire_page(:controller => :welcome)
	end
end