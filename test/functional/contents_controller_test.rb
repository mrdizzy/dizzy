require File.dirname(__FILE__) + '/../test_helper'
require 'contents_controller'

# Re-raise errors caught by the controller.
class ContentsController; def rescue_action(e) raise e end; end

class ContentsControllerTest < Test::Unit::TestCase
	
	fixtures :contents
	fixtures :users
	fixtures :versions

  def setup
    @controller = ContentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # HTML
  
  def test_index_should_display_new_category_form_when_administrator_logged_in
    get :index, {}, { :administrator_id => users(:mr_dizzy).id }
    assert_select "form[action=\"#{categories_path}\"]", { :count => 1}
  end
  
 def test_index_should_not_display_new_category_form_when_administrator_not_logged_in
   get :index
   assert_select "form[action=\"#{categories_path}\"]", false, "There should be no new category form"
 end
 
 def test_index_should_enable_editing_of_article_when_administrator_logged_in
 	get :index, {}, { :administrator_id => users(:mr_dizzy).id }
   assert_select 'a', { :count => 3, :text => "edit"}
   assert_select 'a', { :count => 3, :text => "delete"}
 	assert_response :success
 end
 
 def test_index_should_not_enable_editing_of_article_when_administrator_not_logged_in
 	get :index
   assert_select "a", {:count => 0, :text => "edit"}
   assert_select "a", {:count => 0, :text => "delete"}
 	assert_response :success
 end
 
 def test_index_should_show_add_new_category_form_when_admin_logged_in
  get :index, {}, { :administrator_id => users(:mr_dizzy).id }
     assert_select "form"
     assert_response :success
  end
 	
end
