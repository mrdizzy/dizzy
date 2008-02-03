class CategoriesController < ApplicationController
	
	def index 
		@categories = Category.find(:all)
	end
	
	def show
		@category = Category.find_by_permalink(params[:id])	
	end
	
end