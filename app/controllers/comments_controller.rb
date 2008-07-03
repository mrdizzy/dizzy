class CommentsController < ApplicationController
	
	cache_sweeper 	:comment_sweeper, :only => [ :destroy, :update, :create ]	
	
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
				@parent_comment 	= Comment.find(params[:comment_id])	
				@parent_comment.children << @comment			
				if @parent_comment.save
					@comment = @parent_comment.children.last
					wants.js { render :action => "create_child.rjs"}
					CommentMailer.deliver_response(@parent_comment)			
					CommentMailer.deliver_notification(@comment)			
				else
					wants.js { render :action => "new_child.rjs"}
				end		
			else
				@content 	= Content.find(params[:content_id])	
				@content.comments << @comment			
				if @content.save
					@comment = @content.comments.last
					CommentMailer.deliver_notification(@comment)	
					wants.js
				else
					wants.js { render :action => "new.rjs"}
				end
			end			
		end							
	end

end