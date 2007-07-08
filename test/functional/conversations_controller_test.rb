require File.dirname(__FILE__) + '/../test_helper'
require 'conversations_controller'

# Re-raise errors caught by the controller.
class ConversationsController; def rescue_action(e) raise e end; end

class ConversationsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ConversationsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
