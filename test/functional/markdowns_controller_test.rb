require File.dirname(__FILE__) + '/../test_helper'

class MarkdownsControllerTest < ActionController::TestCase

  def test_truth() assert true   end
  
  def setup
    @markdown = "### Hello\n\nThis is some markdown\n\nAnd *some* more.\n"
  end
  
  def test_1_should_succeed_on_returning_html_from_markdown
  	post :create, :content => @markdown
    
  	assert_response :success
    assert_equal "<h3 id='hello'>Hello</h3>\n\n<p>This is some markdown</p>\n\n<p>And <em>some</em> more.</p>", @response.body
  end
    
end
