# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	
	require_dependency 'content'
	require_dependency 'binary'
	
	helper_method :administrator?
	
 private
 
 	def authorize		
		unless administrator?
			flash[:error] = "unauthorized access"
			redirect_to login_path
			false
		end
	end 
 
	def administrator?
		session[:admin_password] == PASSWORD
	end
	
end