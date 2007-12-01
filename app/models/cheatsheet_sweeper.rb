class CheatsheetSweeper < ActionController::Caching::Sweeper
	
	observe Cheatsheet
	
	def after_save(record)
		expire_cheatsheet_page(record.id)
	end
	
	private
	
	def expire_cheatsheet_page(cheatsheet_id)

		expire_page(:controller => :cheatsheets, :action => :show, :id => cheatsheet_id)
		expire_page(:controller => :cheatsheets, :action => :index)
	end
end