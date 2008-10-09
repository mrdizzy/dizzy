class CommentsController < ApplicationController
	
	cache_sweeper 	:comment_sweeper, :only => [ :destroy, :update, :create ]	
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
	def index
		redirect_to login_path unless administrator?
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
		if administrator?
			@comment = Comment.find(params[:id])
	 	 	@comment.destroy
		else
			redirect_to login_path
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
					wants.js { render :action => "create_child"}
					CommentMailer.deliver_response(@parent_comment)			
					CommentMailer.deliver_notification(@comment)			
				else
					wants.js { render :action => "new_child"}
				end		
			else
				@content 	= Content.find(params[:content_id])	
				@content.comments << @comment			
				if @content.save
					@comment = @content.comments.last
					CommentMailer.deliver_notification(@comment)	
					wants.js
				else
					wants.js { render :action => "new"}
				end
			end			
		end							
	end

end