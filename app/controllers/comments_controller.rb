class CommentsController < ApplicationController
	
	cache_sweeper :comment_sweeper, :only => [ :destroy, :update, :create ]	
	
	before_filter :authorize, :only => [:destroy, :index]
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
	
	def new
		@comment 				= Comment.new
		@comment.content_id 	= params[:content_id]
		
		if params[:comment_id]
			render :update do |page|
				page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'child_comment_form'
				page.visual_effect :toggle_blind, "comment_form_#{params[:comment_id]}"
			end
		else
			render :update do |page|
				page.replace_html "add_comment", :partial => 'comment_form'
				page.visual_effect :toggle_blind, :comment_form
			end
		end
	end
	
	def destroy
		@comment = Comment.find(params[:id])
 	 	if @comment.destroy
			render :update do |page|
				page.remove "comment_#{@comment.id}"
			end
		end
	end
	
	def create			
		@comment = Comment.new(params[:comment])
		if params[:comment_id]	
			@comment.content_id = params[:content_id]
			@parent_comment 	= Comment.find(params[:comment_id])	
			@parent_comment.children << @comment			
			if @parent_comment.save
				@comment = @parent_comment.children.last
				render :update do |page|
					page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'single_comment'
				end
				CommentMailer.deliver_response(@parent_comment)			
				CommentMailer.deliver_notification(@comment)			
			else
				render :update do |page|
					page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'child_comment_form'
					page.visual_effect :toggle_blind, "comment_form_#{params[:comment_id]}"
				end
			end		
		else
			@content 	= Content.find(params[:content_id])	
			@content.comments << @comment			
			if @content.save
				CommentMailer.deliver_notification(@comment)	
			else
				render :update do |page|
					page.replace_html "add_comment", :partial => 'single_comment'
				end
			end
		end							
	end

end