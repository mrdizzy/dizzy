require File.dirname(__FILE__) + '/../test_helper'

class CachePortfoliosTest < ActionController::IntegrationTest
   fixtures :companies, :portfolio_items, :portfolio_types
   
  def test_should_cache_on_show
  	assert_cache_pages("/portfolios/#{companies(:heavenly).id}.js")
  end
  
  def test_should_cache_on_index
  	assert_cache_pages("/portfolios")
  end
  
  def test_should_cache_pagination
  	get "/portfolios/page/2.js"
  	assert_response :success
  	assert_cache_pages("/portfolios/page/2.js")
  end

  def test_should_expire_show_on_company_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}.js") do |*urls|
  		delete "/companies/#{companies(:heavenly).id}"
  	end
  end

  def test_should_expire_show_on_portfolio_item_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}.js") do |*urls|
  		delete "/portfolio_items/#{portfolio_items(:heavenly_slip).id}"
  	end
  end
 
end
