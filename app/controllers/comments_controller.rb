class CommentsController < ApplicationController
	
	def new
		@comment 				= Comment.new
		@comment.content_id 	= params[:content_id]
		
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
		if params[:comment_id]	
			comment 	= Comment.find(params[:comment_id])			
			comment.children.create(params[:comment])			
		else
			@content 	= Content.find(params[:content_id])		
			@content.comments.create(params[:comment])
		end
	end

end