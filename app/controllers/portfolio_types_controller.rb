class PortfolioTypesController < ApplicationController
  
	before_filter 	:authorize, :except => :show
	
	cache_sweeper 	:portfolio_type_sweeper, :only => [ :create, :update, :destroy ]
	caches_page 	:show
	
	def show
		@portfolio_type = PortfolioType.find(params[:id])
		respond_to do |wants|
			wants.png { send_data(@portfolio_type.header_binary, :type => "image/png", :disposition => 'inline') }
		end
	end
	
	def index
  		@portfolio_types = PortfolioType.all
  end

  def new
    @portfolio_type = PortfolioType.new
  end

  def create
    @portfolio_type = PortfolioType.new(params[:portfolio_type])
  	
  	if @portfolio_type.save
      flash[:notice] = 'PortfolioType was successfully created.'
      redirect_to :action => "index"
   else
      render :action => 'new'
    end
  end

  def edit
       	@portfolio_types = PortfolioType.find(:all, :order => 'position')
  end

  def update
		@portfolio_types = PortfolioType.update(params[:portfolio_type].keys, params[:portfolio_type].values)
		if @portfolio_types.all? { |value| value.errors.empty? }
				redirect_to :action => "index"
		else
			render :action => 'edit'
		end		
  end

  def destroy
    PortfolioType.find(params[:id]).destroy
    redirect_to :action => "index"
  end	
	
end