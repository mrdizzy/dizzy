class CommentSweeper < ActionController::Caching::Sweeper
	
	observe Comment
	
	def after_save(record)
		expire_content_page(record)

	end
	
	def after_destroy(record)
		expire_content_page(record)
	end
	
	private
	
	def expire_content_page(record)
		content = record.content
		if content.is_a?(Cheatsheet)			
			expire_page hash_for_cheatsheet_path(:id => content.permalink)
		end
		expire_page hash_for_content_path(:id => content.permalink)		
	end
end