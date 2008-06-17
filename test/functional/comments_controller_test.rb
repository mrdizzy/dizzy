require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
	
	fixtures :comments
    fixtures :contents

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  def index_should_list_all_comments
   get :index
   assert_response :success
  end
  
  def test_create_child_comment
  	
  	num_deliveries = ActionMailer::Base.deliveries.size
  	get :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com', :content_id => 6 }, :comment_id => "2" 
  	
  	assert_template("create_child.rjs")

  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size
  	
  end
  	
end
