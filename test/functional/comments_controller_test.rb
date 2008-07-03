require File.dirname(__FILE__) + '/../test_helper'
require 'comments_controller'

# Re-raise errors caught by the controller.
class CommentsController; def rescue_action(e) raise e end; end

class CommentsControllerTest < Test::Unit::TestCase
	
	fixtures :comments
    fixtures :contents
    fixtures :users

  def setup
    @controller = CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # Index
  
  def test_do_not_show_comments_index_to_unauthorized_user
   get :index
   assert_redirected_to login_path
  end
 
  def show_comments_index_to_authorized_user
  	get :index, {}, { :administrator_id => users(:mr_dizzy).name }
  	assert_template("index.rhtml")
  	assert_response :success
  end 
  
  # Main comments
  
 def test_create_main_comment
  	num_deliveries = ActionMailer::Base.deliveries.size
  	get :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com' }, :content_id => 6
  	
  	assert_template("create.rjs")
  		# Email sent to myself
  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size
  end  
  
  def test_new_main_comment 	
  	get :new, :content_id => 6
  	assert_template("new.rjs")
  end
  
  # Child comments
  
  def test_new_child_comment
  	get :new, :content_id => 6, :comment_id => "2"
  	assert_template("new_child.rjs")
  	end

  def test_invalid_child_comment
  	get :new, :comment => comments(:invalid_child), :content_id => 6, :comment_id => 2
  	assert_template("new_child.rjs") 
	end    	
  	
  def test_invalid_main_comment
  	get :new, :comment => comments(:bad_comment), :content_id => 6
  	assert_template("new.rjs") 
	end  

  def test_create_child_comment
  	num_deliveries = ActionMailer::Base.deliveries.size
  	get :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com', :content_id => 6 }, :comment_id => "2" 
  	
  	assert_template("create_child.rjs")
  	
  		# Email sent to author of parent comment
  		# and to myself
  	assert_equal num_deliveries+2, ActionMailer::Base.deliveries.size
  end

  # Destroy

  def test_destroy_comment_logged_in
  	delete :destroy, :id => "1"
  	assert_template("destroy.rjs")
  	assert_response :success
  end

end
