class CommentsController < ApplicationController
	
	cache_sweeper :comment_sweeper, :only => [ :destroy, :update, :create ]	
	
	before_filter :authorize, :only => [:destroy, :index]
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
   
	def new
		@comment = Comment.new
		
		render :update do |page|
			page.replace_html "new_comment", :partial => 'comment_form'
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
         render :update do |page|
            page.replace "new_comment", :partial => 'comment', :object => @comment 
			end
      else
         render :update do |page|
            page.replace_html "new_comment", :partial => 'comment_form'
         end
      end
      
	end

end