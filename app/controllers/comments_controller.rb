class CommentsController < ApplicationController
	
	def new
		@comment 				= Comment.new
		@comment.content_id 	= params[:content_id]
		
		respond_to do |wants|

		 	if params[:comment_id]
		 		wants.js { render :action => 'new_child.rjs' }	
	 		else
	 			wants.js
 			end
	 	end
	end
	
	
	def create			
		respond_to do |wants|
			
			if params[:comment_id]	
				@content 	= Comment.find(params[:comment_id])			
				if @content.children.create(params[:comment])	
					@comment = @content.children.last
					wants.js { render :action => "create_child.rjs"}
				else
					wants.js { render :action => "new_child.rjs"}
				end		
			else
				@content 	= Content.find(params[:content_id])					
				if @content.comments.create(params[:comment])
					@comment = @content.comments.last
					wants.js
				else
					wants.js { rend :action => "new_child.rjs"}
				end
			end			
		end					
	end

end