class CategoriesController < ApplicationController
	helper :contents
	
	def show
		unless (read_fragment( :action => "show" ) && administrator? == false) || (read_fragment( :action => "show", :part => "administrator" ) && administrator? == true)
			@category = Category.find_by_permalink(params[:id])	
			puts @category.name	
		end
	end

	def create
	 	@category = Category.new(params[:category])
	 	respond_to do |wants|
		 	if @category.save
		 		wants.html
		 		wants.js	
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
	
  	def new
  		@category = Category.new
  		@id = params[:id]
  		render :update do |page|
  			page.replace_html :add_new_category, :partial => "shared/admin/add_new_category"
  		end
  	end
  	
end