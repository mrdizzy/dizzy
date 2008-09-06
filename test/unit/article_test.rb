require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < Test::Unit::TestCase
	fixtures :users, :contents, :categories, :versions
  
  def test_truth
    assert true
  end
  
  def setup
  	@form_helpers = contents(:form_helpers_snippet)
  end
  
  def test_should_fail_on_empty_style
  	@form_helpers.style = ""
  	@form_helpers.valid?
  	assert_equal "can't be blank", @form_helpers.errors.on(:style), @form_helpers.errors.full_messages
  	assert_equal 1, @form_helpers.errors.size
  end
  
  def test_should_fail_on_invalid_style
  	@form_helpers.style = "PURPLE"
  	@form_helpers.valid?
  	assert_equal "is not included in the list", @form_helpers.errors.on(:style), @form_helpers.errors.full_messages
  	assert_equal 1, @form_helpers.errors.size
  end
    
end
