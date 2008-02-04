class ContentsController < ApplicationController
	
	helper :comments	

 	def index
		@content_pages, @contents = paginate :contents, :per_page => 10, :order => "'date' desc"
	end
	
	def show 
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
  	

  def update
    @article = Article.find(params[:id])
    if @article.update_attributes(params[:article])
      flash[:notice] = 'Article was successfully updated.'
      redirect_to categories_path
    else
      render :action => 'edit'
    end
  end  	
	
end