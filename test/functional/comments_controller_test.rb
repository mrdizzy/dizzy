require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase
	
   def main_comments_attributes
      @main_comments_attributes ||= Factory.attributes_for(:comment)
   end
   
   def article
      @article ||= Factory(:article)
   end
   
  def test_truth
    assert true
  end
  
  # Index
  
  def test_1_should_fail_on_index_when_administrator_not_logged_in
   get :index
   assert_redirected_to login_path
  end
 
  def test_2_should_succeed_on_index_when_administrator_not_logged_in
   main_comment = Factory(:comment)
   second_main_comment = Factory(:comment, :content_id => main_comment.content_id)
   
   main_comment.children << [ Factory(:comment, :content_id => main_comment.content_id), Factory(:comment, :content_id => main_comment.content_id) ]
   get :index, {}, { :admin_password => PASSWORD }
  	assert_template("index")

   assert_select "div#comments" do
      Comment.roots.each do |root|
         assert_select "div.root_comment#comment_#{root.id}" do 
            assert_select "h6", :text => /#{root.subject}/
            root.children.each do |child|
               assert_select "div.single_comment#comment_#{child.id}" do
                  assert_select "h6", :text => /#{child.subject}/
               end
            end
         end
      end
   end

  	assert_response :success
  end 
  
  # Create
  
 def test_3_should_succeed_on_create_main_comment_with_valid_attributes_rjs
  	num_deliveries = ActionMailer::Base.deliveries.size
  	xhr(:post, :create, :comment => main_comments_attributes, :content_id => article.id)
  						
  	assert_select_rjs :replace_html
   assert_template "_comment"
   
   comment = assigns(:comment)
   assert_select "div#comment_#{comment.id}" do 
      assert_select "h6", :text => /#{comment.subject}/
      assert_select "p", :text => /#{comment.body}/
   end
   
  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size # Email sent to self
  end     	    
  # New
  
  def test_4_should_succeed_on_new_main_comment_rjs	
  	xhr(:get, :new, :content_id => article.id)
  	assert_template("_comment_form")
  	assert_select_rjs :replace_html, "add_comment"
  end
  
   # Destroy
   
  def test_5_should_succeed_on_destroy_comment_when_administrator_logged_in_rjs
   parent_comment = Factory(:comment)
  	delete :destroy, { :id => parent_comment.id }, { :admin_password => PASSWORD }
  	assert_select_rjs :remove
  	assert_response :success
  end
  
  def test_6_should_fail_on_destroy_comment_when_administrator_not_logged_in_rjs
  	delete :destroy, { :id => "1" }
    assert_redirected_to login_path
  end

end
