class PortfolioTypesController < ApplicationController
  
	before_filter 	:authorize, :except => :show
	cache_sweeper 	:portfolio_type_sweeper, :only => [ :create, :update, :destroy ]
	
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
      redirect_to portfolio_types_path
   else
      render :new
    end
  end

  def edit
       	@portfolio_types = PortfolioType.all(:order => 'position')
  end

  def update
		@portfolio_types = PortfolioType.update(params[:portfolio_type].keys, params[:portfolio_type].values)
		if @portfolio_types.all? { |value| value.errors.empty? }
				redirect_to portfolio_types_path
		else
			render :edit
		end		
  end

  def destroy
    PortfolioType.find(params[:id]).destroy
    redirect_to portfolio_types_path
  end	
	
end