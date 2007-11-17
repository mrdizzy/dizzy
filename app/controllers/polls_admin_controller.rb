class PollsAdminController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @poll_pages, @polls = paginate :polls, :per_page => 10
  end

  def show
    @poll = Poll.find(params[:id])
  end

  def new
    @poll = Poll.new
    5.times { @poll.votes.build }
  end

  def create
    @poll = Poll.new(params[:poll])
    params[:votes].each_value do |item| 
	  	unless item[:option].blank?
	 		@poll.votes.build(item)
	 	end
	end 	  		
		
	if @poll.save 	  		
		redirect_to :action => 'index'  	  			
	else
		render :action => 'new' 
	end
  end

  def edit
    @poll = Poll.find(params[:id])
   
  end

  def update
    @poll = Poll.find(params[:id])
    @poll.attributes = params[:poll]

	@poll.votes.each do |item| 
		if params[:votes][item.id.to_s][:option].blank?
			Vote.delete(item.id)
		else
			item.attributes = params[:votes][item.id.to_s]  
		end
	end
	@poll.save!
	@poll.votes.each(&:save!) 
  end

  def destroy
    Poll.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
