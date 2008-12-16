require File.dirname(__FILE__) + '/../test_helper'

class CachePortfolioItemsTest < ActionController::IntegrationTest
   fixtures :companies, :portfolio_items, :portfolio_types
   
  def test_should_cache_on_show
    assert_cache_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png")
  end
   
  def test_should_expire_show_on_destroy
  	  login
  	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png") do |*urls|
  	  	delete "/portfolio_items/#{portfolio_items(:heavenly_slip).id}"
  	  end 
  end
  
   def test_should_expire_show_on_company_destroy
   	  login
   	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png",
  	  					"/portfolio_items/#{portfolio_items(:heavenly_letterhead).id}.png") do |*urls|
  	  	delete "/companies/#{companies(:heavenly).id}"
  	  end    	
  end 
  
end