class CheatsheetsController < ContentsController
	
  def index	
    @cheatsheets = Cheatsheet.recent
  end
  
  def new
  	if administrator?
		@cheatsheet = Cheatsheet.new
	  	@pdf 		= Pdf.new
  		@thumbnail	= Thumbnail.new
	else 
		redirect_to login_path
	end
  end
  
  def update
  	 @cheatsheet = Cheatsheet.find(params[:id])
  	 @cheatsheet.update_attributes(params[:cheatsheet])
 
    if @cheatsheet.save
      flash[:notice] = 'Cheatsheet was successfully updated.'
      redirect_to cheatsheet_path(@cheatsheet.permalink)
    else
      render :action => 'edit'
    end
  end
  
  def create
  	@cheatsheet = Cheatsheet.new(params[:cheatsheet])
  	@cheatsheet.user_id = session[:administrator_id]
  	
  	 if @cheatsheet.save
      flash[:notice] = 'Cheatsheet was successfully created.'
      redirect_to cheatsheets_path
    else
      render :action => 'new'
    end
  end
  
  def edit
  	if administrator?
  		@cheatsheet =  Cheatsheet.find(params[:id]) 
  	else 
  		redirect_to login_path
  	end 
  end

end