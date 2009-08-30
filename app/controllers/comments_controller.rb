class CommentsController < ApplicationController
	
	cache_sweeper :comment_sweeper, :only => [ :destroy, :update, :create ]	
	
	before_filter :authorize, :only => [:destroy, :index]
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
	
	def new
		@comment = Comment.new(:content_id => params[:content_id])
		
		render :update do |page|
			page.replace_html "add_comment", :partial => 'comment_form'
			page.visual_effect :toggle_blind, :comment_form
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
		@comment = Comment.new(params[:comment].merge({:content_id => params[:content_id]}))
      		
		if @comment.save
			#CommentMailer.deliver_notification(@comment)	
         render :update do |page|
            page.replace_html "add_comment", :partial => 'single_comment'
			end
      end						
	end

end