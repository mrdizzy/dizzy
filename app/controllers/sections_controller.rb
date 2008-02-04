class SectionsController < ApplicationController
	helper :contents
	before_filter :load_category_and_content 	

  def show
    @section = Section.find_by_content_id_and_permalink(@content.id, params[:id])
  end

  def new
    @section = Section.new
    @section.content = Content.find_by_id(@content.id)
  end

  def create
    @section = Section.new(params[:section])
    if @section.save
      flash[:notice] = 'Section was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @section = Section.find(params[:id])
  end

  def update
    @section = Section.find(params[:id])
    if @section.update_attributes(params[:section])
      flash[:notice] = 'Section was successfully updated.'
      redirect_to :action => 'show', :id => @section
    else
      render :action => 'edit'
    end
  end

  def destroy
    Section.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  private
 
  def load_category_and_content
  	@category	= Category.find_by_permalink(params[:category_id])
  	@content	= Content.find_by_permalink(params[:content_id])
  end
end
