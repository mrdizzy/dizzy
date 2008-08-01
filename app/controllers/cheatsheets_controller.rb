class CheatsheetsController < ContentsController
	
  def index	
    @cheatsheets = Cheatsheet.find(:all)
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

    if @cheatsheet.valid?
      flash[:notice] = 'Cheatsheet was successfully updated.'
      redirect_to cheatsheet_path(@cheatsheet.permalink)
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