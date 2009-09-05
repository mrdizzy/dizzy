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
   
  def test_3_should_succeed_on_create_main_comment_with_valid_attributes_html
    post(:create, :comment => main_comments.attributes, :content_id => article.id)
    assert_redirect contents_path(article)
    comment = assigns(:comment)
  end
   
  	assert_equal num_deliveries+1, ActionMailer::Base.deliveries.size # Email sent to self
  end     	    
  
  def test_4_should_succeed_create_valid_child_comment_rjs
    parent_comment = Factory(:comment)
    num_deliveries = ActionMailer::Base.deliveries.size
    xhr(:post, :create, :comment => main_comments_attributes, :comment_id => parent_comment.id, :content_id => parent_comment.content_id)

    assert_select_rjs :replace_html
    assert_template("_comment")

    comment = assigns(:comment)

    assert_select "div#comment_#{comment.id}" do 
      assert_select "h6", :text => /#{comment.subject}/
      assert_select "p", :text => /#{comment.body}/
    end
    
    assert_equal num_deliveries+2, ActionMailer::Base.deliveries.size, "Deliveries should be the same" # Email sent to author of parent comment and self
  end  
  
 def test_5_should_fail_on_create_invalid_child_comment_rjs
   parent_comment = Factory(:comment)
  
  	xhr(:post, :create, :comment => { :body => "Here is a comment" }, :content_id => parent_comment.content_id, :comment_id => parent_comment.id)
   
   child_comment = assigns(:comment)
   
   assert_equal "can't be blank", child_comment.errors[:name]   
   assert_equal "can't be blank", child_comment.errors[:subject]
   assert_equal "can't be blank", child_comment.errors[:email]
   
  	assert_template("_comment_form") 
  	assert_select_rjs
	end 
     
  
  # N E W 
  
  def test_6_should_succeed_on_new_main_comment_rjs	
  	xhr(:get, :new, :content_id => article.id)
  	assert_template("_comment_form")
  	assert_select_rjs :replace_html, "new_comment_",  :partial => 'comment_form'
  end
  
  def test_7_should_succeed_on_new_main_comment_html
    get(:new, :content_id => article.id)
    assert_template("new")
    savefile(@response.body)
  end
  
  def test_7_should_succeed_on_new_child_comment_form_rjs
    parent_comment = Factory(:comment)
    xhr(:get, :new, :content_id => article.id, :comment_id => parent_comment.id)
    assert_template("_comment_form")
    assert_select_rjs :replace_html, "new_comment_#{parent_comment.id}", :partial => 'comment_form'
  end
  
   # Destroy
   
  def test_8_should_succeed_on_destroy_comment_when_administrator_logged_in_rjs
   parent_comment = Factory(:comment)
  	delete :destroy, { :id => parent_comment.id }, { :admin_password => PASSWORD }
  	assert_select_rjs :remove
  	assert_response :success
  end
  
  def test_9_should_fail_on_destroy_comment_when_administrator_not_logged_in_rjs
  	delete :destroy, { :id => "1" }
    assert_redirected_to login_path
  end

end
