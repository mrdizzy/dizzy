require File.dirname(__FILE__) + '/../test_helper'

class ChildCommentsControllerTest < ActionController::TestCase
	
   def main_comments_attributes
      @main_comments_attributes ||= Factory.attributes_for(:comment)
   end
   
   def article
      @article ||= Factory(:article)
   end
   
  def test_truth
    assert true
  end

  # Create

  def test_1_should_succeed_create_valid_child_comment_rjs
   parent_comment = Factory(:comment)
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:post, :create, :comment => main_comments_attributes, :comment_id => parent_comment.id, :content_id => parent_comment.content_id)
   
   assert_select_rjs :replace_html
  	assert_template("_single_comment")
   
    comment = assigns(:comment)
    
   assert_select "div#comment_#{comment.id}" do 
      assert_select "h6", :text => /#{comment.subject}/
      assert_select "p", :text => /#{comment.body}/
   end
  	
  	assert_equal num_deliveries+2, ActionMailer::Base.deliveries.size, "Deliveries should be the same" # Email sent to author of parent comment and self
  end
  
  def test_2_should_fail_on_create_invalid_child_comment_rjs
   parent_comment = Factory(:comment)
  
  	xhr(:post, :create, :comment => { :body => "Here is a comment" }, :content_id => parent_comment.content_id, :comment_id => parent_comment.id)
   
   child_comment = assigns(:comment)
   
   assert_equal "can't be blank", child_comment.errors[:name]   
   assert_equal "can't be blank", child_comment.errors[:subject]
   assert_equal "can't be blank", child_comment.errors[:email]
   
  	assert_template("_child_comment_form") 
  	assert_select_rjs
	end 
   
  # New
  
  def test_3_should_succeed_on_new_child_comment_form_rjs
   parent_comment = Factory(:comment)
  	xhr(:get, :new, :content_id => article.id, :comment_id => parent_comment.id)
  	assert_template("_child_comment_form")
  	end
   
end
