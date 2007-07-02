class ContentController < ApplicationController
	
	def show 
		@content = Content.find_by_permalink(params[:permalink])		
		@comment = Comment.new		
		@categories = Category.find(:all, :order => :name)
		if @content.is_a?(Article) 
			render (:template => "content/article")
		else
			render (:template => "content/cheatsheet")
		end
	end
	
	def create_comment 
		@article = Article.find(params[:id])
		@article.comments.create(params[:comment])
	end
	
	def create_child_comment 
		@comment = Comment.find(params[:id])		
		@comment.children.create(params[:comment])
	end	
	
	def reply
		render :update do |page|
			page.replace_html "reply_#{params[:id]}", :partial => 'comment_form', :locals => { :comment => Comment.new, :id => params[:id] }
		end
	end
	
	def articles_for_category 
		@category = Category.find_by_permalink(params[:permalink])
			
		@results = @category.contents		
	end
	def comment_form 
		
		render :update do |page|
			page.insert_html :after, "add_comment", :partial => "main_comment_form", :locals => { :comment => Comment.new, :id => params[:id] }
			
			page.remove "add_comment"
		end
	end
	
end