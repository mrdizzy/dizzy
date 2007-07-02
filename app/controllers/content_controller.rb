class ContentController < ApplicationController
	
	def show 
		@article = Article.find_by_permalink(params[:permalink])		
		@comment = Comment.new		
		@categories = Category.find(:all, :order => :name)
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
		@results = [ @category.cheatsheets, @category.articles].flatten
		@results.sort! { |a,b| b.date <=> a.date }		
	end
end