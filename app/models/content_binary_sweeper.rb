class ContentBinarySweeper < ActionController::Caching::Sweeper
	
	observe ContentBinary
	
	def after_save(content_binary)
		puts "yes!!!"
		expire_page(:controller => "binaries", :action=> "get_cheatsheet_pdf", :permalink => content_binary.content.permalink, :extension => "pdf")
	end

end