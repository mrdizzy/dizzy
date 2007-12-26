class CheatsheetsController < ApplicationController
	helper :content
	layout "content"
	def index
   		list
   
	end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
         
	def list
		@content_pages, @contents = paginate :cheatsheets, :per_page => 10, :order => "'date' desc"		
		render(:template => "content/list")
	end
end