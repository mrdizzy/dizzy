require File.dirname(__FILE__) + '/../test_helper'

class CachePortfolioItemsTest < ActionController::IntegrationTest
   
  def test_1_should_cache_on_show
    item = Factory(:portfolio_item)
    assert_cache_pages("/portfolio_items/#{item.id}.png")
  end
   
  def test_2_should_expire_show_on_destroy
      item = Factory(:portfolio_item)
  	  login
  	  assert_expire_pages("/portfolio_items/#{item.id}.png") do |*urls|
  	  	delete "/portfolio_items/#{item.id}"
  	  end 
  end
  
   def test_3_should_expire_show_on_company_destroy
      company = Factory(:company)
   	  login
   	  assert_expire_pages("/portfolio_items/#{company.portfolio_items.first.id}.png") do |*urls|
  	  	delete "/companies/#{company.id}"
  	  end    	
  end 
  
end