class ContentController < ApplicationController
	
	def show 
		@article = Article.find(params[:id])
		@categories = Category.find(:all, :order => :name)
	end
	
	def articles_for_category 
		@category = Category.find(params[:id])
	end
end
