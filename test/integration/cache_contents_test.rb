require File.dirname(__FILE__) + '/../test_helper'

class CacheContentsTest < ActionController::IntegrationTest
   
  def test_1_should_cache_cheatsheet_on_show
      cheatsheet = Factory.create(:cheatsheet, :permalink => "action-mailer", :pdf => Factory.build(:pdf))
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer")
  	  assert_cache_pages("/ruby_on_rails/cheatsheets/action-mailer.pdf")
  end
  
  def test_2_should_expire_show_cheatsheet_on_destroy
     cheatsheet = Factory.create(:cheatsheet, :permalink => "action-mailer", :pdf => Factory.build(:pdf))
  	  login
  	  assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer",
  	  					"/ruby_on_rails/cheatsheets/action-mailer.pdf") do |*urls|
			delete "/ruby_on_rails/cheatsheets/#{cheatsheet.id}"
      end
  end  
  
  def test_3_should_expire_show_cheatsheet_on_update
  cheatsheet = Factory.create(:cheatsheet, :permalink => "action-mailer", :pdf => Factory.build(:pdf))
  	login
  	assert_expire_pages("/ruby_on_rails/cheatsheets/action-mailer") do |*urls|
  		put "/ruby_on_rails/cheatsheets/#{cheatsheet.id}", { :cheatsheet => { :permalink => "boo-boo"} }
  	end
  end
  
  def test_4_should_cache_article_on_show
    article = Factory.create(:article, :permalink => "store-file-uploads-in-database")
  	assert_cache_pages("/ruby_on_rails/contents/store-file-uploads-in-database")
  end
  
  def test_5_should_expire_show_article_on_destroy
  
  article = Factory.create(:article, :permalink => "store-file-uploads-in-database")
  	login
  	assert_expire_pages("/ruby_on_rails/contents/store-file-uploads-in-database") do |*urls|
  		delete "/ruby_on_rails/contents/#{article.id}"
  	end
  end
  
  def test_6_should_expire_show_article_on_update
  
  article = Factory.create(:article, :permalink => "store-file-uploads-in-database")
  	login
  	assert_expire_pages("/ruby_on_rails/contents/store-file-uploads-in-database") do |*urls|
  		put "/ruby_on_rails/contents/#{article.id}", { :article => { :permalink => "boo-boo"} }
  	end
  end
 
  def test_7_should_expire_show_contents_on_comments_create
    article = Factory.create(:article, :permalink => "store-file-uploads-in-database")
  	assert_expire_pages("/ruby_on_rails/contents/#{article.permalink}") do |*urls|
  		post content_comments_path(article.id), 
  								{ :comment => { 	
  												:subject => "Hello", 
		  										:body => "This is a comment", 
		  										:name => "Malandra Mysogynist", 
		  										:email => 'malandra@dutyfree.com' }, 
  								:content_id => article.id  									
  								}
  	end
  end
  
    def test_8_should_expire_show_contents_on_comments_destroy
    
      cheatsheet = Factory.create(:cheatsheet, :permalink => "action-mailer", :pdf => Factory.build(:pdf))
    login
  	assert_expire_pages("/ruby_on_rails/cheatsheets/#{cheatsheet.permalink}") do |*urls|
  		delete comment_path(comments(:great_grandmother).id)
  	end
  end
 
end