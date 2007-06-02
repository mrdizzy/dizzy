require File.dirname(__FILE__) + '/../test_helper'
require 'binaries_controller'

# Re-raise errors caught by the controller.
class BinariesController; def rescue_action(e) raise e end; end

class BinariesControllerTest < Test::Unit::TestCase
  def setup
    @controller = BinariesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
