class ChildCommentsController < ApplicationController
	
	def new
		@comment = Comment.new
		
		render :update do |page|
			page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'child_comment_form'
			page.visual_effect :toggle_blind, "comment_form_#{params[:comment_id]}"
		end
		
	end
	
	def create			
		@comment = Comment.new(params[:comment].merge({:content_id => params[:content_id], :parent_id => params[:comment_id]}))
     
		if @comment.save
          render :update do |page|
				page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'comments/single_comment'
			end
      else
         render :update do |page|
				page.replace_html "reply_form_#{params[:comment_id]}", :partial => 'child_comment_form'
            page.visual_effect :toggle_blind, "comment_form_#{params[:comment_id]}"
         end
      end						
	end

end