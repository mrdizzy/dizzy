class ContentAdminController < ApplicationController
	before_filter :authorize
	
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

  def add_new_user
  	@user = User.new  
  		render :update do |page|
			page.replace_html :add_new_user, :partial => 'add_new_user'
		end	
  end 
  
  def create_author 
  	@author = Author.new(params[:author]) 
  	if @author.save
  		render :update do |page|
			page.replace_html :select_author, :partial => 'select_author'
			page.visual_effect(:highlight, :select_author, :duration => 1.5, :endcolor => "'#ffffff'", :startcolor => "'#D1ECF9'")
			page.replace_html :add_new_author, :partial => 'add_new_author_link'
		end
    else  		
    	render :update do |page|
			page.replace_html :add_new_author, :partial => 'add_new_author'
		end			
    end  	
  end  
  
end