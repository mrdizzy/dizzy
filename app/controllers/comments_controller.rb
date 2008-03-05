class CommentsController < ApplicationController
	
	def index
		if administrator?
			@latest = Content.recent
		else 
			redirect_to login_path
		end
	end
	
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
	
	def destroy
		@comment = Comment.find(params[:id])
 	 	@comment.destroy
 	 	respond_to do |wants|
 	 		wants.js
 	 	end
	end
	
	def create			
		@comment = Comment.new(params[:comment])
		
		respond_to do |wants|	
			if params[:comment_id]	
				@content 	= Comment.find(params[:comment_id])	
				@content.children << @comment			
				if @content.save!
					@comment = @content.children.last
					wants.js { render :action => "create_child.rjs"}
				else
					wants.js { render :action => "new_child.rjs"}
				end		
			else
				@content 	= Content.find(params[:content_id])	
				@content.comments << @comment			
				if @content.save
					@comment = @content.comments.last
					wants.js
				else
					wants.js { render :action => "new.rjs"}
				end
			end			
		end					
	end

end