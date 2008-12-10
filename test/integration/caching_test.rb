require '../test_helper'

class CachingTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions,  :companies, :portfolio_items, :portfolio_types
   
  def test_show_cheatsheet_should_cache_cheatsheet_and_expire_on_destroy
  	  
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer", 
  	  	   						"/ruby_on_rails/latest",
  	  	   						"/")
  	  login
  	  assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer", 
  	   							"/ruby_on_rails/latest", 
  	   							"/") do |*urls|
			post "/cheatsheets/destroy/#{contents(:action_mailer_cheatsheet).id}"
      end
  end
  
  def test_show_portfolio_item_should_cache_portfolio_item_png_and_expire_on_destroy
  	  assert_cache_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png")
  	  
  	  login
  	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png") do |*urls|
  	  	post "/portfolio_items/destroy/#{portfolio_items(:heavenly_slip).id}"
  	  end 
  end
  
   def test_destroy_company_should_expire_portfolio_items
   	login
   	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png",
  	  					"/portfolio_items/#{portfolio_items(:heavenly_letterhead).id}.png") do |*urls|
  	  	post "/companies/destroy/#{companies(:heavenly).id}"
  	  end    	
  end

  def test_show_portfolio_type_should_cache_portfolio_type_png_and_expire_on_destroy
	assert_cache_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png")
    login
	assert_expire_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png") do |*urls|
  	  	post "/portfolio_types/destroy/#{portfolio_types(:business_card).id}"
  	  end  
  end
  
  def login
  	 post "/administrator_sessions", :admin_password => PASSWORD
  end
    
end
