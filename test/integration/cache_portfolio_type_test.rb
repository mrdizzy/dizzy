require '../test_helper'

class CachePortfolioTypeTest < ActionController::IntegrationTest
   fixtures :portfolio_types
   
  def test_should_cache_on_show
	assert_cache_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png")
  end
  
  def test_should_expire_on_destroy
    login
	assert_expire_pages("/portfolio_types/#{portfolio_types(:business_card).id}.png") do |*urls|
  	  	post "/portfolio_types/destroy/#{portfolio_types(:business_card).id}"
  	  end  
  end
  
end