class ContentBinarySweeper < ActionController::Caching::Sweeper
	
	observe ContentBinary
	
	def after_save(content_binary)
expire_binary(content_binary.content.permalink)
	
	end
	
	def after_destroy(content_binary)
		expire_binary(content_binary.content.permalink)
	end
	
	private 
	
	def expire_binary(permalink)
			expire_page(:controller => "binaries", :action=> "get_cheatsheet_pdf", :permalink => permalink, :extension => "pdf")
	end
end