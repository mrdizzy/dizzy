require '../test_helper'

class CachingTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions,  :companies, :portfolio_items, :portfolio_types
   
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
  	  
  	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png") do |*urls|
  	  	post "/portfolio_items/destroy/#{portfolio_items(:heavenly_slip).id}"
  	  end
  	  
  	  puts portfolio_items(:heavenly_slip).company.name
  	  
  	   assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png") do |*urls|
  		companies(:heavenly).portfolio_items.each_with_index do |item,index|
  			puts item.portfolio_type
  			puts item.filename
  			puts index
  		end
  	  	post "/companies/destroy/#{companies(:heavenly).id}"
  	  end
  end
    
end
