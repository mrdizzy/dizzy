# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
	require 'bluecloth'
	require_dependency 'content'	
	
		include ExceptionNotifiable
#local_addresses.clear
 # def local_request?
  #  return false
 # end
 #def rescue_action_in_public(exception)   
  #    	puts params
   #     case exception        	
    #      when ::ActionController::RoutingError, ::ActionController::UnknownAction then
	#	render :template => "error404/index", :layout => false, :status => "404"   
     #     else
      #      render_text(IO.read(File.join(RAILS_ROOT, 'public', '500.html')), "500 Internal Error")
      #  end
     # end   
     private
	def authorize
		unless User.find_by_id(session[:user_id])
			flash[:notice] = "Please log in"
			redirect_to(:controller => "login" , :action => "login" )
		end
	end
end