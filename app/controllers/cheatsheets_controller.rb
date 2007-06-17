class CheatsheetsController < ApplicationController
	layout "content"
	 caches_page :index, :show
	 def index
  	 	@cheatsheet_pages, @cheatsheets = paginate :cheatsheets, :per_page => 10, :order => "'date' desc"
 	 end

	def show
		puts params[:permalink]
		@cheatsheet = Cheatsheet.find_by_permalink(params[:permalink])
	end
end
