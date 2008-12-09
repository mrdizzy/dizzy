class ContentsController < ApplicationController
	
	helper 			:comments		
	caches_page 	:show, :index
	cache_sweeper 	:content_sweeper, :only => [ :destroy, :update, :create ]
	
  before_filter :authorize, :except => [ :index, :show ]
	
	def index 
		@latest = Content.recent
	end
	
	def show 
		@content 		= Content.find_by_permalink(params[:id])		
		@comment 		= Comment.new				
		@categories 	= Category.find(:all, :order => :name)
		respond_to do |wants|
			wants.html { render :template => "contents/show"}
			wants.pdf { send_data(@content.pdf.binary_data, :type => "application/pdf", :disposition => 'inline') }
			wants.png { send_data(@content.thumbnail.binary_data, :type => "image/png", :disposition => 'inline') }
		end
	end
	
	def edit 
    	@article = Article.find(params[:id]) 
  	end
  	
  	def new
  		@article = Article.new
  	end

  def update
    @article = Article.find(params[:id])
    
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Successfully updated.'
      redirect_to content_path(@article.permalink)
    else
      render :action => 'edit'
    end
  end  	
	
	def create
		@article = Article.new(params[:article])
		@article.user_id = session[:administrator_id]
		
		if @article.save
      		flash[:notice] = 'Successfully created.'
      		redirect_to latest_path
    	else
      		render :action => 'new'
   		end
	end
	
	def destroy
		@content = Content.find(params[:id])
		@content.destroy
	end
end