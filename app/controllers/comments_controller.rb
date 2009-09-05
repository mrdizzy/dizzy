class CommentsController < ApplicationController
	
	cache_sweeper :comment_sweeper, :only => [ :destroy, :update, :create ]	
	
	before_filter :authorize, :only => [:destroy, :index]
	
	# TODO: If administrator logged in, then create comments from administrator rather than external user 
	# TODO: Make email field optional to avoid readers putting in fake emails
   
	def new
		@comment = Comment.new(:parent_id => params[:comment_id])
    @parent_id = params[:comment_id]
		
    respond_to do |format|
      format.html
      
      format.js do 
        render :update do |page|
          page.replace_html "new_comment_#{@parent_id}", :partial => 'comment_form'
        end
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
		@comment = Comment.new(params[:comment].merge({:content_id => params[:content_id]}))
    
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
            page.replace_html "new_comment_#{@comment.parent_id}", :partial => 'comment', :object => @comment 
          else
            page.replace_html "new_comment_#{@comment.parent_id}", :partial => 'comment_form'
          end
        end
      end
      
    end
      
	end

end