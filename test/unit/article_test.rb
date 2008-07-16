require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
	fixtures :users, :contents, :categories, :categories_contents
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def setup
  	@form_helpers = contents(:form_helpers_article)
  end
  
  # Style
    
  def test_fail_when_empty_style
  	@form_helpers.style = ""
  	assert !@form_helpers.valid?, "Article should not be valid"
  end
  
  def test_succeed_when_valid
  	assert @form_helpers.valid?, @form_helpers.errors.full_messages
  end
    
end
