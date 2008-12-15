require File.dirname(__FILE__) + '/../test_helper'

class CacheContentsTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions
   
  def test_should_cache_cheatsheet_on_show
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer")
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer.png")
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer.pdf")
  end
  
  def test_should_cache_article_on_show
  end
  
  def test_should_expire_show_cheatsheet_on_destroy
  	  login
  	  assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer",
  	  					"/ruby_on_rails/cheatsheets/action-mailer.png",
  	  					"/ruby_on_rails/cheatsheets/action-mailer.pdf") do |*urls|
			post "/cheatsheets/destroy/#{contents(:action_mailer_cheatsheet).id}"
      end
  end  
 
end