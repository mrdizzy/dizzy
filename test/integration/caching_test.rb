require '../test_helper'

class CachingTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions, :portfolio_items, :companies, :portfolio_types

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
 
  def test_caching_of_cheatsheet_pages
  	  post "/administrator_sessions", :admin_password => PASSWORD
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer", 
  	  	   						"/ruby_on_rails/latest",
  	  	   						"/")
  	   
  	   assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer", 
  	   							"/ruby_on_rails/latest", 
  	   							"/") do |*urls|
  	   		post "/cheatsheets/destroy/#{contents(:action_mailer_cheatsheet).id}"
       end
  end
  
 def test_caching_of_portfolio_items
  	  post "/administrator_sessions", :admin_password => PASSWORD
  	  assert_cache_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png")
  end  
end
