class CommentSweeper < ActionController::Caching::Sweeper
	
	observe Comment
	
	def after_save(record)
		expire_content_page(record)
	end
	
	def after_destroy(record)
		expire_content_page(record)
	end
	
	private
	
	def expire_content_page(comment)
		expire_page content_path(:id => comment.content.permalink)	
	end
end