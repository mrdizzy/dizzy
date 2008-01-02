class ContentController < ApplicationController
	
	helper :comments
	
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
	
	def show 
		@content = Content.find_by_permalink(params[:permalink])		
		@comment = Comment.new		
		@categories = Category.find(:all, :order => :name)
		if @content.is_a?(Article) 
			render(:template => "content/article")
		else
			render(:template => "content/cheatsheet")
		end
	end
	
	def articles_for_category 
		@category = Category.find_by_permalink(params[:permalink])			
		@results = @category.contents		
	end	
	
	def list_cheatsheets 
		@results = Cheatsheet.find(:all)
			render(:template => "content/articles_for_category")
	end
end