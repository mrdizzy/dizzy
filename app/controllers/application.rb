# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	include ExceptionNotifiable
	require_dependency 'content'	
	require_dependency 'binary'
	require_dependency 'ticket'
	require_dependency 'conversation'
	

 private
	def authorize
		
		unless User.find_by_id(session[:user_id])
			flash[:notice] = "Please log in"
	
		
			redirect_to(:controller => "login" , :action => "login" )
		end
	end
end