class ApplicationController < ActionController::Base
  protect_from_forgery

  
    helper :all 
  helper_method :administrator?

protected

  def local_request?() false	end

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
