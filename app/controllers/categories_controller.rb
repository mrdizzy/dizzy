class CategoriesController < ApplicationController
	helper :contents

	def show
		@category = Category.find_by_permalink(params[:id])
	end

	def create
	 	@category = Category.new(params[:category])
		if administrator? 
			redirect_to new_category_path unless @category.save 
		end
	end	

 	def destroy
 	  @category = Category.find(params[:id])
	  @category.destroy if administrator?
 	end
  	
end