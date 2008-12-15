require File.dirname(__FILE__) + '/../test_helper'

class CacheContentsTest < ActionController::IntegrationTest
   fixtures :contents, :binaries, :categories, :versions
   
  def test_should_cache_cheatsheet_on_show
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer")
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer.png")
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer.pdf")
  end
  
  def test_should_expire_show_cheatsheet_on_destroy
  	  login
  	  assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer",
  	  					"/ruby_on_rails/cheatsheets/action-mailer.png",
  	  					"/ruby_on_rails/cheatsheets/action-mailer.pdf") do |*urls|
			delete "/ruby_on_rails/cheatsheets/#{contents(:action_mailer_cheatsheet).id}"
      end
  end  
  
  def test_should_cache_article_on_show
  	assert_cache_pages("/ruby_on_rails/contents/store-file-uploads-in-database")
  end
  
  def test_should_expire_show_article_on_destroy
  	login
  	assert_expire_pages("/ruby_on_rails/contents/store-file-uploads-in-database") do |*urls|
  		delete "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}"
  	end
  end
  
  def test_should_cache_index_cheatsheets
  	assert_cache_pages("/ruby_on_rails/cheatsheets")
  end
  
  def test_should_expire_index_cheatsheets_on_destroy
  	login
  	assert_expire_pages("/ruby_on_rails/cheatsheets") do |*urls|
  		delete "/ruby_on_rails/cheatsheets/#{contents(:action_mailer_cheatsheet).id}"
  	end  	
  end
  
  def test_should_cache_index_contents
  	assert_cache_pages("/ruby_on_rails/latest")
  end
  
  def test_should_expire_index_contents_on_destroy
  	login
  	assert_expire_pages("/ruby_on_rails/latest") do |*urls|
  		delete "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}"
  	end  	
  end
  
  def test_should_expire_index_welcome_on_contents_destroy
  	login
  	assert_expire_pages("/") do |*urls|
  		delete "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}"
  	end  	
  end
 
  def test_should_cache_index_contents_rss
  	assert_cache_pages("/ruby_on_rails/contents.rss")
  end
  
  def test_should_expire_index_contents_rss_on_contents_destroy
  	login
  	assert_expire_pages("/ruby_on_rails/contents.rss") do |*urls|
  		delete "/ruby_on_rails/contents/#{contents(:file_uploads_tutorial).id}"
  	end  	
  end  
 
end