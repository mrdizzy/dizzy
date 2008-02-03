class ContentsController < ApplicationController
	
	helper :comments	

 	def index
		@content_pages, @contents = paginate :contents, :per_page => 10, :order => "'date' desc"
	end
	
	def show 
		@content 		= Content.find_by_permalink(params[:id])		
		@comment 		= Comment.new				
		@categories 	= Category.find(:all, :order => :name)
		
		if @content.is_a?(Article) 
			render(:template => "contents/article")
		else
			render(:template => "contents/cheatsheet")
		end
	end
	
end