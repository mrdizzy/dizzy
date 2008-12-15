require File.dirname(__FILE__) + '/../test_helper'

class CachePortfolioTypeTest < ActionController::IntegrationTest
   fixtures :portfolio_types
   
  def test_should_cache_on_show
	assert_cache_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png")
  end
  
  def test_should_expire_on_destroy
    login
	assert_expire_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png") do |*urls|
  	  	delete "/portfolio_types/#{portfolio_types(:business_card).id}"
  	  end  
  end
  
end