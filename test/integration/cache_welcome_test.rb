require File.dirname(__FILE__) + '/../test_helper'

class CacheContentsTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions, :comments, :companies, :portfolio_items, :portfolio_types
   
  def test_should_expire_welcome_index_on_contents_destroy
  	login
  	assert_expire_pages("/") do |*urls|
  		delete "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}"
  	end  	
  end
 
   def test_should_expire_welcome_index_on_contents_update
  	login
  	assert_expire_pages("/") do |*urls|
  		put "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}", { :article => { :permalink => "boo-boo"} }
  	end  	
  end
  
    def test_should_expire_welcome_index_on_cheatsheets_destroy
  	login
  	assert_expire_pages("/") do |*urls|
  		delete "/ruby_on_rails/cheatsheets/#{contents(:action_mailer_cheatsheet).id}"
  	end  	
  end
 
   def test_should_expire_welcome_index_on_cheatsheets_update
  	login
  	assert_expire_pages("/") do |*urls|
  		put "/ruby_on_rails/cheatsheets/#{contents(:action_mailer_cheatsheet).id}", { :cheatsheet => { :permalink => "boo-boo"} }
  	end  	
  end
  
  def test_should_expire_welcome_page_on_company_destroy
  	login
  	assert_expire_pages("/") do |*urls|
	   delete "/companies/#{companies(:heavenly).id}"
	end
  end
  
    def test_should_expire_welcome_page_on_portfolio_item_destroy
  	login
  	assert_expire_pages("/") do |*urls|
	   delete "/portfolio_items/#{portfolio_items(:heavenly_slip).id}"
	end
  end
  
end