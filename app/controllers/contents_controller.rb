class ContentsController < ApplicationController
	
	helper 			:comments		
	caches_page 	:show
	cache_sweeper 	:content_sweeper, :only => [ :destroy, :update, :create ]
	
	def index 
		@latest = Content.recent
	end
	
	def show 
		@content 		= Content.find_by_permalink(params[:id])		
		@comment 		= Comment.new				
		@categories 	= Category.find(:all, :order => :name)
		respond_to do |wants|
			wants.html { @content.is_a?(Article) ? render(:template => "contents/article") : render(:template => "contents/cheatsheet") }
			wants.pdf { send_data(@content.pdf.binary_data, :type => "application/pdf", :disposition => 'inline') }
			wants.png { send_data(@content.thumbnail.binary_data, :type => "image/png", :disposition => 'inline') }
		end
	end
	
	def edit
    	if administrator? 
    		@article = Article.find(params[:id]) 
    	else 
    		redirect_to login_path  
    	end
  	end
  	
  	def new
  		if administrator?
  			@article = Article.new
  		else
  			redirect_to login_path
  		end
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