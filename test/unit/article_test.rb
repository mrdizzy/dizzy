require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  
  def test_truth
    assert true
  end
  
  def test_1_should_fail_with_empty_content
  	article = Factory.build(:article, :content => "")
	  article.valid?
  	assert_equal "can't be blank", article.errors[:content], "Should have error on blank"
  end 
  
  def test_2_should_destroy_article
	  article = Factory(:article)
  	assert_difference('Article.count', -1) do
  		article.destroy
  	end
  end
    
end
