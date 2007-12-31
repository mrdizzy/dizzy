class CommentsController < ApplicationController
	
	def reply
		render :update do |page|			
			page.insert_html :after, "reply_#{params[:id]}", :partial => 'comment_form', :locals => { :comment => Comment.new, :id => params[:id] }
			
			page.visual_effect :toggle_blind, :comment_form
			page.replace_html "reply_#{params[:id]}", ""
		end
	end
	
	def create_comment 
		@content = Content.find(params[:id])			
		@content.comments.create(params[:comment])
	end
	
	def create_child_comment 
		@comment = Comment.find(params[:id])		
		@comment.children.create(params[:comment])
	end	
	
	def comment_form 		
		render :update do |page|
			page.insert_html :after, "add_comment", :partial => "main_comment_form", :locals => { :comment => Comment.new, :id => params[:id] }	
			page.visual_effect :toggle_blind, :main_comment_form		
			page.remove "add_comment"
		end
	end	

end