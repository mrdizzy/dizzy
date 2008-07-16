class CategoriesController < ApplicationController
	helper :contents

	def show
		@category = Category.find_by_permalink(params[:id])	
	end

	def create
	 	@category = Category.new(params[:category])
	 	respond_to do |wants|
		 	if @category.save
		 		wants.js { puts "NO" }
	 		else 
	 			wants.html { redirect_to new_category_path }
	 			wants.js { puts render :action => :new}
	 		end
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