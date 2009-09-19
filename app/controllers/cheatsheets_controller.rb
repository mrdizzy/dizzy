class CheatsheetsController < ContentsController
	
  def index	
    @cheatsheets = Cheatsheet.recent
  end
 
 def show
 	@content    = Cheatsheet.permalink(params[:id])
	@comment 		= Comment.new				
	@categories = Category.all	
		respond_to do |wants|
			wants.html { render :template => "contents/show"}
			wants.pdf { render :binary, @content => :pdf }
		end 
	end
  
  def new
    @cheatsheet = Cheatsheet.new
  end
  
  def update
  	 @cheatsheet = Cheatsheet.find(params[:id])
 
    if @cheatsheet.update_attributes(params[:cheatsheet])
      flash[:notice] = 'Cheatsheet was successfully updated.'
      redirect_to cheatsheet_path(@cheatsheet.permalink)
    else
      render :edit
    end
  end
  
  def create
  	@cheatsheet = Cheatsheet.new(params[:cheatsheet])
  	@cheatsheet.user = "mr_dizzy"
	
  	if @cheatsheet.save
      flash[:notice] = 'Cheatsheet was successfully created.'    
      redirect_to cheatsheet_path(@cheatsheet.permalink)
    else
      render :new
    end
  end
  
  def edit
  	@cheatsheet = Cheatsheet.find(params[:id]) 
  end

end