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
		expire_page content_path(:id => permalink)
	end
	
	def expire_welcome_page
		expire_page(:controller => :welcome)
	end
end