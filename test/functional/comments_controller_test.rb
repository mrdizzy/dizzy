require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
	
  def test_truth
    assert true
  end
  
  def test_should_fail_on_index_when_administrator_not_logged_in
   get :index
   assert_redirected_to login_path
  end
 
  def test_should_succeed_on_index_when_administrator_not_logged_in
  	get :index, {}, { :admin_password => PASSWORD }
  	assert_template("index")
  	assert_response :success
  end 
  
 def test_should_succeed_on_create_main_comment_with_valid_attributes_rjs
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:post, :create, :comment => { 	:subject => "Hello", 
  										:body => "This is a comment", 
  										:name => "Malandra Mysogynist", 
  										:email => 'malandra@dutyfree.com' }, 
  						:content_id => contents(:action_mailer_cheatsheet).id)
  						
  	assert_template("create")
  	assert_select_rjs

  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size # Email sent to self
  end  
  
  def test_should_succeed_on_new_main_comment_rjs	
  	xhr(:get, :new, :content_id => contents(:action_mailer_cheatsheet).id)
  	assert_template("new")
  	assert_select_rjs
  end
  
  def test_should_succeed_on_new_child_comment_form_rjs
  	xhr(:get, :new, :content_id => contents(:action_mailer_cheatsheet).id, :comment_id => "2")
  	assert_template("new_child")
  	assert_select_rjs
  	end

  def test_should_succeed_new_html_child_comment_form
  	get(:new, :content_id => contents(:action_mailer_cheatsheet).id, :comment_id => "2")
  	assert_template("new_child")
  end

  def test_should_fail_create_invalid_child_comment_rjs
  	xhr(:get, :new, :comment => { :body => "Here is a comment" }, :content_id => contents(:action_mailer_cheatsheet).id, :comment_id => comments(:mother).id)
  	assert_template("new_child") 
  	assert_select_rjs
	end    	

  def test_should_succeed_create_valid_child_comment_rjs
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:get, :create, :comment => { :subject => "Hello", :body => "This is a comment", :name => "Malandra Mysogynist", :email => 'malandra@dutyfree.com' }, :comment_id => comments(:mother).id, :content_id => contents(:action_mailer_cheatsheet).id)
  	
  	assert_template("create_child")
  	assert_select_rjs
  	
  	assert_equal num_deliveries+2, ActionMailer::Base.deliveries.size # Email sent to author of parent comment and self
  end
  
  def test_should_succeed_on_destroy_comment_when_administrator_logged_in_rjs
  	delete :destroy, { :id => comments(:mother).id }, { :admin_password => PASSWORD }
  	assert_template("destroy")
  	assert_select_rjs
  	assert_response :success
  end
  
  def test_should_fail_on_destroy_comment_when_administrator_not_logged_in_rjs
  	delete :destroy, { :id => "1" }
    assert_redirected_to login_path
  end

end
