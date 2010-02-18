class CommentPreviewsController < ApplicationController
	
	def create			
		@comment = Comment.new(params[:comment])
    
    respond_to do |format|     
      format.js do
          if @comment.valid?
            render :partial => "comment_preview"
		      else
            render :partial => "comment_preview_form", :status => 409
          end        
      end      
    end
      
	end

end