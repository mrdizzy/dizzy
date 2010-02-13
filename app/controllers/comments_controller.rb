class CommentsController < ApplicationController
	
	cache_sweeper :comment_sweeper, :only => [ :destroy, :update, :create ]	
	before_filter :authorize, :only => [:destroy, :index]
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
   
	def new
		@comment = Comment.new(:parent_id => params[:comment_id])
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
    
    respond_to do |format|
      format.html do 
         if @comment.save
            redirect_to content_path(@comment.content.permalink)
         else
            render :new
         end
      end
      
      format.js do
        render :update do |page|
          if @comment.save
            page.insert_html :bottom, "comment_#{@comment.parent_id}", :partial => 'comment', :object => @comment			
            page.hide "form_comment_#{@comment.parent_id}"
            page.replace_html "form_comment_#{@comment.parent_id}", :partial => 'comment_form', :object => Comment.new(:parent_id => @comment.parent_id, :content_id => @comment.content_id)
			page << "$('#{@comment.id}').observe('click', toggleReplyCommentForm)"
			page << "$('form_comment_#{@comment.id}').observe('submit', sendCommentForm)"			
          else
            page.replace_html "form_comment_#{@comment.parent_id}", :partial => 'comment_form', :object => @comment 
			page << "$('new_comment_#{@comment.object_id}').observe('submit', sendCommentForm)"
          end
        end
      end
      
    end
      
	end

end