class ContentAdminController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @article_pages, @articles = paginate :articles, :per_page => 10, :order => "'date' desc"
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
  
    if @article.save
      flash[:notice] = 'Article was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])    
  end

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated.'
      redirect_to :action => 'edit', :id => @article
    else
      render :action => 'edit'
    end
  end

  def destroy
    Article.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
## Categories ##########################################
  	
	def articles_for_category 
		@category = Category.find(params[:id])
	end
	
 def delete_categories  
 	 @categories = Category.find(params[:categories])
 	 	 Category.delete(params[:categories])
 	 render :update do |page|
 	 	@categories.each do |category| 	 		
 	 		@category = category
 	 		page.replace_html category.id.to_s, :partial => "deleted_category"
 	 	end
 	 end
 end
 
  def categories 
  	@categories = Category.find(:all, :order => :name)
  end
 
 def create_new_category
 	@category = Category.new(params[:category])
 	if @category.save 
 		render :update do |page|
 			page.insert_html :bottom, :categories, :partial => "category_check_box"
 			page.visual_effect(:highlight, @category.id.to_s, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'")
 		end
 	end
 end
 
  def add_new_category
  	@category = Category.new
  	@id = params[:id]
  	render :update do |page|
  		page.replace_html :add_new_category, :partial => "add_new_category"
  	end
  end
  
  def create_category 
  	@category = Category.new(params[:category])  	
  	@article = Article.find(params[:id]) if params[:id]
  	if @category.save 
  		@article.categories << @category if params[:id]
		render :update do |page|
			page.replace_html :select_category, :partial => 'select_category'
			page.visual_effect :highlight, :select_category, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'"
			page.replace_html :add_new_category, :partial => 'add_new_category_link'
		end
    else  		
    	render :update do |page|
			page.replace_html :add_new_category, :partial => 'add_new_category'
		end			
    end  	
  end  
  
## Authors ##########################################

  def add_new_author 
  	@author = Author.new  
  		render :update do |page|
			page.replace_html :add_new_author, :partial => 'add_new_author'
		end	
  end 
  
  
  def create_author 
  	@author = Author.new(params[:author]) 
  	if @author.save
  		render :update do |page|
			page.replace_html :select_author, :partial => 'select_author'
			page.visual_effect(:highlight, :select_author, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'")
			page.replace_html :add_new_author, :partial => 'add_new_author_link'
		end
    else  		
    	render :update do |page|
			page.replace_html :add_new_author, :partial => 'add_new_author'
		end			
    end  	
  end  
  
  # File uploads ##########################################
  
  def update_binary
  	render :update do |page|
  		page.insert_html :after, :article_content, "![Alt text]"
  	end
  end
  
  def file_upload_form
  	@binary = Binary.new
  	render :update do |page|
  		page.insert_html :after, :admin_links, :partial => "file_upload_form"
  	end
  end
  
  def upload_file
  	@binary = Binary.new(params[:binary])
  	@binary.save	
  		
  end
end