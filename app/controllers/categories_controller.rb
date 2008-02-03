class CategoriesController < ApplicationController
	
	def index 
		@categories = Category.find(:all)
	end
	
	def show
		@category = Category.find_by_permalink(params[:id])	
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
  
  	def ajax_create
  		@category = Category.new(params[:category])  	
  		@content = Content.find(params[:id]) if params[:id]
	  	if @category.save 
	  		@content.categories << @category if params[:id]
			render :update do |page|
				page.replace_html :select_main_category, :partial => 'shared/admin/select_main_category'
				page.replace_html :select_subcategory, :partial => 'shared/admin/select_subcategory'			
				page.visual_effect :highlight, :select_main_category, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'"
				page.visual_effect :highlight, :select_subcategory, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'"			
				page.replace_html :add_new_category, :partial => 'shared/admin/add_new_category_link', :object => @content
			end
	    else  		
	    	render :update do |page|
				page.replace_html :add_new_category, :partial => 'shared/admin/add_new_category'
			end			
	    end  	
	end  
end