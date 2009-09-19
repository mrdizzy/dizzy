class CategoriesController < ApplicationController

	before_filter :authorize, :except => :show

	def show
		@category = Category.find_by_permalink(params[:id])
	end

	def create
	 	@category = Category.new(params[:category])

		if @category.save 
			render :update do |page| 
				page.insert_html :bottom, :category_list, :partial => "category_link"
				page.visual_effect(:highlight, "category_#{@category.id.to_s}", :duration => 1.5, :endcolor => "#ffffff", :startcolor => "#D1ECF9")
			end
		else
			render :new
		end				
	end
   
 	def destroy
 	  @category = Category.find(params[:id])
	  	if @category.destroy
	  		render :update do |page|
	  			page.replace_html "category_#{@category.id}", "<del>#{@category.name}</del>"
  			end
  	    end
 	end
end