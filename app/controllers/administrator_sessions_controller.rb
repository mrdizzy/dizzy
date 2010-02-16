class AdministratorSessionsController < ApplicationController
	
	def create
		session[:admin_password] = params[:admin_password]
		if administrator?
			flash[:notice] = "Successfully logged in"
			redirect_to contents_path
		else
			flash[:notice] = "Invalid password"
			render :action => "new"
		end
	end
	
	def destroy
		reset_session
		flash[:notice] = "Successfully logged out"
		redirect_to contents_path
	end

end