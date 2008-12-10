require '../test_helper'

class CachePortfoliosTest < ActionController::IntegrationTest
   fixtures :companies, :portfolio_items, :portfolio_types
   
  def test_should_cache_on_show
  	assert_cache_pages("/portfolios/#{companies(:heavenly).id}")
  	assert_cache_pages("/portfolios/#{companies(:heavenly).id}.js")
  end 
  
  def test_should_cache_on_index
  	assert_cache_pages("/portfolios.js")
  end
  
  def test_should_expire_show_on_company_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}", "/portfolios/#{companies(:heavenly).id}.js") do |*urls|
  		post "/companies/destroy/#{companies(:heavenly).id}"
  	end
  end
  
  def test_should_expire_show_on_portfolio_item_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}", "/portfolios/#{companies(:heavenly).id}.js") do |*urls|
  		post "/portfolio_items/destroy/#{portfolio_items(:heavenly_slip).id}"
  	end
  end  
  
    
end
