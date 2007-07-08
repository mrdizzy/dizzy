class LoginController < ApplicationController

  def add_user
  	@user = User.new(params[:user])
  	if request.post? and @user.save
		flash.now[:notice] = "User #{@user.name} created"
		@user = User.new
	end
  end

  def login
	session[:user_id] = nil
	if request.post?
		user = User.authenticate(params[:name], params[:password])
		if user
			session[:user_id] = user.id
			redirect_to(:controller => "content_admin", :action => "list" )
		else
		flash[:notice] = "Invalid user/password combination"
		end
	end
  end

  def logout
  end


  def delete_user
  end

  def list_users
  end
end
