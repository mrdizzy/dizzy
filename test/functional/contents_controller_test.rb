require File.dirname(__FILE__) + '/../test_helper'
require 'contents_controller'

# Re-raise errors caught by the controller.
class ContentsController; def rescue_action(e) raise e end; end

class ContentsControllerTest < Test::Unit::TestCase
	
	fixtures :contents
	fixtures :users
	fixtures :versions
	fixtures :comments

  def setup
    @controller = ContentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # Index - category form
  
  def test_index_should_display_new_category_form_when_administrator
    get :index, {}, { :administrator_id => users(:mr_dizzy).id }
    assert_select "form[action=\"#{categories_path}\"]", { :count => 1}
    assert_response :success
  end
  
 def test_index_should_not_display_new_category_form_when_not_administrator
   get :index
   assert_select "form[action=\"#{categories_path}\"]", false, "There should be no new category form"
   assert_response :success
   
 end
 
 # Index - edit/delete links
 
 def test_index_should_enable_editing_of_article_when_administrator
 	get :index, {}, { :administrator_id => users(:mr_dizzy).id }
 	content = Content.find(:all)
   assert_select 'a', { :count => content.size, :text => "edit"}
   assert_select 'a', { :count => content.size, :text => "delete"}
 	assert_response :success
 end
 
 def test_index_should_not_enable_editing_of_article_when_not_administrator
 	get :index
   assert_select "a", {:count => 0, :text => "edit"}
   assert_select "a", {:count => 0, :text => "delete"}
 	assert_response :success
 end
 
 #  Add category form
 
 def test_index_should_show_new_category_form_when_administrator
  get :index, {}, { :administrator_id => users(:mr_dizzy).id }
     assert_select "form"
     assert_response :success
  end
 	
 	def test_should_show_no_category_form_when_not_administrator
	 	get :show, :id => "rails-migrations"
	 
 	end
 	
 	# New
 	
 	def test_should_show_new_form_when_administrator
 		get :new, {}, { :administrator_id => users(:mr_dizzy).id }
 		assert_response :success
 	end
 	
 	def test_should_fail_new_form_when_not_administrator
 		get :new
 		assert_redirected_to login_path
 	end
 	
 	# Edit
 	
 	def test_should_show_edit_form_when_administrator
 		get :edit, {:id => 10}, { :administrator_id => users(:mr_dizzy).id }
 		assert_response :success
 	end
 	
 	def test_should_fail_edit_form_when_not_administrator
 		get :edit, :id => 10
 		assert_redirected_to login_path
 	end
 	
 	def test_should_show_comments
 		get :show, { :id => "rails-migrations" }
 		comments = Comment.find_all_by_content_id(1)
		comments.each do |comment|
			assert_select "div#comment_#{comment.id}"
		
		end
	
 		assert_response :success
 	end
 	
end