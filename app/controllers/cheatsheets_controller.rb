class CheatsheetsController < ApplicationController
	helper :contents
	before_filter :load_category
	cache_sweeper :content_sweeper, :only => [ :destroy, :update ]
	
  def index
    @category = Category.find_by_permalink(params[:category_id])		
    @cheatsheets = @category.cheatsheets
  end
  
  def new
  	@cheatsheet = Cheatsheet.new
  	@cheatsheet.main_category = @category.id
  	@pdf 		= Pdf.new
  	@thumbnail	= Thumbnail.new
  end
  
  def destroy
	 @cheatsheet = Cheatsheet.find(params[:id])
	 @cheatsheet.destroy
  end  	
  
  def update
  	 @cheatsheet = Cheatsheet.find(params[:id])
  	 @cheatsheet.update_attributes(params[:cheatsheet])
 
  	 unless params[:pdf][:uploaded_data].blank?
  	 	if @cheatsheet.pdf 	 	
  	 			@cheatsheet.pdf.update_attributes(params[:pdf])
		else 
			@cheatsheet.pdf = Pdf.new(params[:pdf])
		end
	end
	unless params[:thumbnail][:uploaded_data].blank?
		if @cheatsheet.thumbnail	 	
			@cheatsheet.thumbnail.update_attributes(params[:thumbnail])
  	 		
		else 
			@cheatsheet.thumbnail = Thumbnail.new(params[:thumbnail])
		end
	end

    if @cheatsheet.valid? && @cheatsheet.pdf.valid? && @cheatsheet.thumbnail.valid? && @cheatsheet.categories.all?(&:valid?)
      flash[:notice] = 'Cheatsheet was successfully updated.'
      redirect_to :action => "index"
    else
      render :action => 'edit'
    end
  end
  
  def create
  	@cheatsheet = Cheatsheet.new(params[:cheatsheet])
  	@cheatsheet.user_id = session[:administrator_id]
  	unless params[:pdf][:uploaded_data].blank?
  		@pdf = Pdf.new(params[:pdf])
	     @cheatsheet.pdf = @pdf
  	end
  	unless params[:thumbnail][:uploaded_data].blank?
  		@thumbnail = Thumbnail.new(params[:thumbnail])
    	 @cheatsheet.thumbnail = @thumbnail
     end

  	 if @cheatsheet.valid?
  	 	@cheatsheet.save
      flash[:notice] = 'Cheatsheet was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end
  
  def edit
  	@cheatsheet =  Cheatsheet.find(params[:id])  
  end
  
  private
  
  def load_category
  	@category = Category.find_by_permalink(params[:category_id])
  end

end