class ContentController < ApplicationController
	
	def show 
		@article = Article.find_by_permalink(params[:permalink])
		puts @article.id
		@categories = Category.find(:all, :order => :name)
	end
	
	def articles_for_category 
		@category = Category.find_by_permalink(params[:permalink])
	end
end