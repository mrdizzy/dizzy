require '../test_helper'

class CachingTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def test_delete_cheatsheet
  	  # post "/administrator_sessions", :admin_password => PASSWORD
  	 #  assert_redirected_to latest_path
  	   
  	  # get "/ruby_on_rails/cheatsheets/action-mailer"
  	 #  assert_response :success
  	   

  end
 
  def test_caching
  	  post "/administrator_sessions", :admin_password => PASSWORD
  	  	   assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer", 
  	  	   						"/ruby_on_rails/latest",
  	  	   						"/ruby_on_rails/contents/debugging-form-helpers-with-the-console",
  	  	   						"/")
  	   
  	   assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer", "/ruby_on_rails/latest", "/") do |*urls|
      	post "/cheatsheets/destroy/#{contents(:action_mailer_cheatsheet).id}"
      	post "/contents/destroy/#{contents(:form_helpers_snippet).id}"
       end
  end
end
