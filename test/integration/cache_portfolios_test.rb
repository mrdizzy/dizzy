require File.dirname(__FILE__) + '/../test_helper'

class CachePortfoliosTest < ActionController::IntegrationTest
   fixtures :companies, :portfolio_items, :portfolio_types
   
  def test_should_cache_on_show
  	get "/portfolios/#{companies(:heavenly).id}.js"
  	assert_response :success
  	
  	assert_cache_pages("/portfolios/#{companies(:heavenly).id}.js")
  	assert_cache_pages("/portfolios/#{companies(:heavenly).id}")
  end

  def test_should_expire_show_on_company_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}.js", "/portfolios/#{companies(:heavenly).id}") do |*urls|
  		delete "/companies/#{companies(:heavenly).id}"
  	end
  end

  def test_should_expire_show_on_portfolio_item_destroy
  	login
  	assert_expire_pages("/portfolios/#{companies(:heavenly).id}.js", "/portfolios/#{companies(:heavenly).id}") do |*urls|
  		delete "/portfolio_items/#{portfolio_items(:heavenly_slip).id}"
  	end
  end  
  
  def test_should_cache_on_index
  	get "/portfolios"
  	assert_response :success
  	
  	assert_cache_pages("/portfolios")
  end
  
  def test_should_expire_index_on_company_destroy
  	login
  	assert_expire_pages("/portfolios") do |*urls|
  		delete "/companies/#{companies(:heavenly).id}"
  	end
  end
  
  def test_should_expire_index_on_company_update
  	login
  	assert_expire_pages("/portfolios") do |*urls|
  		put "/companies/#{companies(:heavenly).id}", { :company => { :name => "Jupiter Smith Ltd" } }
  	end
  end
  
  def test_should_cache_pagination
  	get "/portfolios/page/2.js"
  	assert_response :success
  	
  	assert_cache_pages("/portfolios/page/2.js")
  end
  
  def test_should_expire_pagination_on_company_destroy
	login
  	assert_expire_pages("/portfolios/page/2.js") do |*urls|
  		delete "/companies/#{companies(:heavenly).id}"
  	end
  end
  
  def test_should_expire_pagination_on_company_update
  	flunk
  end
 
end
