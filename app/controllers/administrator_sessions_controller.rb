class AdministratorSessionsController < ApplicationController
	
	def create
		session[:administrator_id] = nil
		if request.post?
			administrator = User.authenticate(params[:username], params[:password])
			if administrator
				session[:administrator_id] = administrator.id
				redirect_to latest_path
			else
			flash[:notice] = "Invalid user/password combination"
				redirect_to(:action => "new")
			end
		end
	end
	
	def destroy
		session[:administrator_id] = nil
		redirect_to(categories_path)
	end

end
