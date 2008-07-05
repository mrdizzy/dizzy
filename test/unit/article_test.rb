require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
  fixtures :contents

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # Style
    
  def test_fail_when_empty_style
  	article = contents(:form_helpers_article)
  	article.style = ""
  	assert !article.valid?, "Article should not be valid"
  end
  
  def test_succeed_when_valid_style
  	article = contents(:form_helpers_article)
  	assert article.valid?, article.errors.full_messages
  end
  
end
