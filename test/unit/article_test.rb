require File.dirname(__FILE__) + '/../test_helper'

class ArticleTest < ActiveSupport::TestCase
  fixtures :contents, :categories, :versions
  
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
  	assert_equal 1, @form_helpers.errors.size, @form_helpers.errors.full_messages
  end
  
  def test_should_fail_on_invalid_style
  	@form_helpers.style = "PURPLE"
  	@form_helpers.valid?
  	assert_equal "is not included in the list", @form_helpers.errors.on(:style), @form_helpers.errors.full_messages
  	assert_equal 1, @form_helpers.errors.size
  end
  
  def test_should_fail_with_empty_body
  	@form_helpers.content = ""
  	assert "can't be empty", @form_helpers.errors.invalid?(:content)
  end 
  
  def test_should_destroy_article
  	assert_difference('Article.count', -1) do
  		@form_helpers.destroy
  	end
  end
    
end
