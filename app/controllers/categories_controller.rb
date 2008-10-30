class CategoriesController < ApplicationController
	helper :contents

	def show
		@category = Category.find_by_permalink(params[:id])
	end

	def create
	 	@category = Category.new(params[:category])
		if administrator? 
			if @category.save 
				render :update do |page| 
					page.insert_html :bottom, :category_list, :partial => "category_link"
					page.visual_effect(:highlight, "category_#{@category.id.to_s}", :duration => 1.5, :endcolor => "#ffffff", :startcolor => "#D1ECF9")
				end
			else
				redirect_to new_category_path 
			end				
		else
	  		flash[:error] = "Sorry, you are not logged in"
	  		render :update do |page|
  				page.replace_html :new_category_form, :partial => "form"
  			end
  	 	end
	end	

 	def destroy
 	  @category = Category.find(params[:id])
	  if administrator?
	  	if @category.destroy
	  		render :update do |page|
	  			page.replace_html "category_#{@category.id}", "<del>#{@category.name}</del>"
  			end
  	    end
  	  else
  		flash[:error] = "Sorry, you are not logged in"
  		render :update do |page|
  			page.replace_html :new_category_form, :partial => "form"
  		end
  	  end
 	end
  	
end