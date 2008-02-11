class ContentsController < ApplicationController
	
	helper 			:comments		
	caches_page 	:show, :index
	cache_sweeper 	:content_sweeper, :only => [ :destroy, :update ]
	
	def index 
		@latest = Content.recent
	end
	
	def show 
		load "#{RAILS_ROOT}/app/helpers/contents_helper.rb"
		@content 		= Content.find_by_permalink(params[:id])		
		@comment 		= Comment.new				
		@categories 	= Category.find(:all, :order => :name)
		respond_to do |wants|
			wants.html do 
				if @content.is_a?(Article) 
					render(:template => "contents/article")
				else
					render(:template => "contents/cheatsheet")
				end
			end
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
      flash[:notice] = 'Article was successfully updated.'
      redirect_to categories_path
    else
      render :action => 'edit'
    end
  end  	
	
	def create
		@article = Article.new(params[:article])
		@article.user_id = session[:administrator_id]
		if @article.valid?
  	 		@article.save
      		flash[:notice] = 'Cheatsheet was successfully created.'
      		redirect_to :action => 'list'
    	else
      		render :action => 'new'
   		end
	end
	
	def destroy
		if Content.find(params[:id]).destroy
			redirect_to categories_path
		end
	end
end