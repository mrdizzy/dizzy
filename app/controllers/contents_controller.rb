class ContentsController < ApplicationController
		
	caches_page 	:show
	cache_sweeper 	:content_sweeper, :only => [ :destroy, :update, :create ]
	
 	before_filter 	:authorize, :except => [ :index, :show ]
	
	def index 
		@latest = Content.recent
	end
	
	def show 
		@content 		= Article.find_by_permalink(params[:id])			
	end
	
	def edit 
    	@article = Article.find(params[:id]) 
  	end
  	
  	def new
  		@article = Article.new
  	end
  	
  	def preview
  		@content = params[:content]
  		result = "Use numbered headers: true
HTML use syntax: true

{:rhtml: lang=rhtml html_use_syntax=true}
{:ruby: lang=ruby  html_use_syntax=true}

" + @content
		@content = Maruku.new(result).to_html

  	end

  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Successfully updated.'
      redirect_to content_path(@article.permalink)
    else
      render :edit
    end
  end  	
	
	def create
		@article = Article.new(params[:article])
		@article.user = "mr_dizzy"
		
		if @article.save
      		flash[:notice] = 'Successfully created.'
      		redirect_to latest_path
    	else
      		render :new
   		end
	end
	
	def destroy
		@content = Content.find(params[:id])
		@content.destroy
	end
end