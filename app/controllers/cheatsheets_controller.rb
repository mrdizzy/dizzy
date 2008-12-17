class CheatsheetsController < ContentsController
	
  def index	
    @cheatsheets = Cheatsheet.recent
  end
 
 def show
 	@content = Cheatsheet.find_by_permalink(params[:id])
	@comment 		= Comment.new				
	@categories 	= Category.find(:all, :order => :name) 	
		respond_to do |wants|
			wants.html { render :template => "contents/show"}
			wants.pdf { send_data(@content.pdf.binary_data, :type => "application/pdf", :disposition => 'inline') }
			wants.png { send_data(@content.thumbnail.binary_data, :type => "image/png", :disposition => 'inline') }
		end 
	end
  
  def new
	@cheatsheet = Cheatsheet.new
  	@pdf 		= Pdf.new
	@thumbnail	= Thumbnail.new
  end
  
  def update
  	 @cheatsheet = Cheatsheet.find(params[:id])
 
    if @cheatsheet.update_attributes(params[:cheatsheet])
      flash[:notice] = 'Cheatsheet was successfully updated.'
      redirect_to cheatsheet_path(@cheatsheet.permalink)
    else
      render :action => 'edit'
    end
  end
  
  def create
  	@cheatsheet = Cheatsheet.new(params[:cheatsheet])
  	@cheatsheet.user = "mr_dizzy"
  	 
  	 if @cheatsheet.save
      flash[:notice] = 'Cheatsheet was successfully created.'
    
      redirect_to cheatsheet_path(@cheatsheet.permalink)
    else
      render :action => 'new'
    end
  end
  
  def edit
  	@cheatsheet =  Cheatsheet.find(params[:id]) 
  end

end