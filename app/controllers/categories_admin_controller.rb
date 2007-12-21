class CategoriesAdminController < ApplicationController
	before_filter :authorize
	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
   	@categories = Category.find(:all, :order => :name)
  end

	def articles_for_category 
		@category = Category.find(params[:id])
	end
	  
 def create
 	@category = Category.new(params[:category])
 	if @category.save 
 		render :update do |page|
 			page.insert_html :bottom, :categories, :partial => "category_check_box"
 			page.visual_effect(:highlight, @category.id.to_s, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'")
 		end
 	end
 end
 
 def destroy
 	 @categories = Category.find(params[:categories])
 	 	 if Category.delete(params[:categories])
		 	 render :update do |page|
		 	 	@categories.each do |category| 	 		
		 	 		@category = category
		 	 		page.replace_html category.id.to_s, :partial => "deleted_category"
		 	 	end
	 	 	end
	 	else
			render :update do |page|
		 	 	@categories.each do |category| 	 		
		 	 		@category = category
		 	 		page.replace_html category.id.to_s, :partial => "delete_category_error"
	 	 	end
		end
 	 end
 end

  def ajax_new
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