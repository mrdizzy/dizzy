class CategoriesController < ApplicationController
	helper :contents

	def show
		@category = Category.find_by_permalink(params[:id])	
	end

	def create
	 	@category = Category.new(params[:category])
	 	respond_to do |format|
		 	puts "------------------------"
		 		format.js { render :action => :create }

	 	end
	end	

 	def destroy
 		@category = Category.find(params[:id])
 	 	respond_to do |wants|
	 	 	if @category.destroy
				wants.html
				wants.js 
			end
		end
 	end
  	
end