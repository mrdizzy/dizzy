require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
	
  fixtures :comments, :contents, :binaries, :users
  	
  def test_truth
    assert true
  end
  
  # Index
  
  def test_do_not_show_comments_index_to_unauthorized_user
   get :index
   assert_redirected_to login_path
  end
 
  def test_show_comments_index_to_authorized_user
  	get :index, {}, { :administrator_id => users(:mr_dizzy).name }
  	assert_template("index")
  		assert_select_rjs
  	assert_response :success
  end 
  
  # Main comments
  
 def test_create_main_comment
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:post, :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com' }, :content_id => contents(:action_mailer_cheatsheet).id)
  	assert_template("create")
  	assert_select_rjs

  		# Email sent to self
  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size
  end  
  
  def test_new_main_comment 	
  	xhr(:get, :new, :content_id => contents(:action_mailer_cheatsheet).id)
  	assert_template("new")
  	assert_select_rjs
  end
  
  def test_fail_invalid_main_comment
  	xhr(:get, :new, :comment => { :name => "Melissa" }, :content_id => contents(:action_mailer_cheatsheet).id)
  	assert_template("new") 
  	assert_select_rjs
	end    
  
  # Child comments
  
  def test_succeed_new_child_comment_form
  	xhr(:get, :new, :content_id => contents(:action_mailer_cheatsheet).id, :comment_id => "2")
  	assert_template("new_child")
  	assert_select_rjs
  	end

  def test_fail_create_invalid_child_comment
  	xhr(:get, :new, :comment => { :body => "Here is a comment" }, :content_id => contents(:action_mailer_cheatsheet).id, :comment_id => comments(:mother).id)
  	assert_template("new_child") 
  	assert_select_rjs
	end    	

  def test_succeed_create_valid_child_comment
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:get, :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com', :content_id => contents(:action_mailer_cheatsheet).id }, :comment_id => comments(:mother).id)
  	
  	assert_template("create_child")
  	assert_select_rjs
  	
  		# Email sent to author of parent comment and self
  	assert_equal num_deliveries+2, ActionMailer::Base.deliveries.size
  end

  # Destroy

  def test_succeed_destroy_comment_with_administrator
  	delete :destroy, { :id => comments(:mother).id }, { :administrator_id => users(:mr_dizzy).name }
  	assert_template("destroy")
  	assert_select_rjs
  	assert_response :success
  end
  
  def test_fail_destroy_comment_without_administrator
  	delete :destroy, { :id => "1" }
    assert_redirected_to login_path
  end

end
