require '../test_helper'

class CachePortfolioItemsTest < ActionController::IntegrationTest
   fixtures :companies, :portfolio_items, :portfolio_types
   
  def test_should_cache_on_show
    	  assert_cache_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png")
  end
   
  def test_should_expire_on_destroy
  	  login
  	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png",
  	  					  "/portfolios/#{portfolio_items(:heavenly_slip).company.id}",
  	  					  "/portfolios/#{portfolio_items(:heavenly_slip).company.id}.js") do |*urls|
  	  	post "/portfolio_items/destroy/#{portfolio_items(:heavenly_slip).id}"
  	  end 
  end
  
   def test_should_expire_on_company_destroy
   	  login
   	  assert_expire_pages("/portfolio_items/#{portfolio_items(:heavenly_slip).id}.png",
  	  					"/portfolio_items/#{portfolio_items(:heavenly_letterhead).id}.png") do |*urls|
  	  	post "/companies/destroy/#{companies(:heavenly).id}"
  	  end    	
  end 
  
end