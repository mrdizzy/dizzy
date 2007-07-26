class PersonTypesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @person_type_pages, @person_types = paginate :person_types, :per_page => 10
  end

  def show
    @person_type = PersonType.find(params[:id])
  end

  def new
    @person_type = PersonType.new
  end

  def create
    @person_type = PersonType.new(params[:person_type])
    if @person_type.save
      flash[:notice] = 'PersonType was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @person_type = PersonType.find(params[:id])
  end

  def update
    @person_type = PersonType.find(params[:id])
    if @person_type.update_attributes(params[:person_type])
      flash[:notice] = 'PersonType was successfully updated.'
      redirect_to :action => 'show', :id => @person_type
    else
      render :action => 'edit'
    end
  end

  def destroy
    PersonType.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
