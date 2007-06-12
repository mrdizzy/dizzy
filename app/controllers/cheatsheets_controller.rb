class CheatsheetsController < ApplicationController
	layout "content"
	 
	 def index
  	 	@cheatsheet_pages, @cheatsheets = paginate :cheatsheets, :per_page => 10, :order => "'date' desc"
 	 end


	def show
		@cheatsheet = Cheatsheet.find(params[:id])
	end
end
