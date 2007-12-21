class ContentAdminController < ApplicationController
	before_filter :authorize
	
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @content_pages, @contents = paginate :contents, :per_page => 10, :order => "'date' desc"
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
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    	#Article.transaction do
		 # @cheatsheet.categories.delete_all
		  @article.destroy
	#  end
  end  
 
end