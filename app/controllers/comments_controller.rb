class CommentsController < ApplicationController
	
	def new
		@comment = Comment.new
		
		respond_to do |wants|
		 	wants.html
		 	if params[:comment_id]
		 		wants.js { render :action => 'new_child.rjs' }	
	 		else
	 			wants.js
 			end
	 	end
	end
	
	def create
		@content 	= Content.find(params[:content_id])			
		@content.comments.create(params[:comment])
		#comment.children.create(params[:comment])
	end

end