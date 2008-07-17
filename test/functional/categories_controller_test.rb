require File.dirname(__FILE__) + '/../test_helper'
require 'categories_controller'

# Re-raise errors caught by the controller.
class CategoriesController; def rescue_action(e) raise e end; end

class CategoriesControllerTest < Test::Unit::TestCase
	
	fixtures :categories
	
  def setup
    @controller = CategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # HTML
  
  def test_should_succeed_on_show_with_valid_permalink
  	get :show, :id => categories(:plugins).permalink
  	assert_response :success
  end
  
  def test_html_should_succeed_on_destroy_with_valid_id
  	delete :destroy, :id => categories(:plugins).id
  	assert_response :success
  end
  
  def test_html_should_succeed_on_create_with_valid_parameters
  	post :create, :category => { :name => "Computing Hardware", :permalink => "computing-hardware" }
  	assert_response :success
  end
  
  def test_html_should_fail_on_create_with_existing_name
  	post :create, :category => { :name => categories(:plugins).name, :permalink => "permalink-here" }
    assert_redirected_to new_category_path
  end
 
  def test_html_should_fail_on_create_with_existing_permalink
  	post :create, :category => { :name => "Brand new name", :permalink => categories(:plugins).permalink }
    assert_redirected_to new_category_path
  end
  
  # RJS
  
  def test_javascript_should_succeed_on_destroy_with_valid_id
  	xml_http_request :delete, :destroy, :id => categories(:plugins).id
  	assert_response :success
  end
  
  def test_javascript_should_succeed_on_create_with_valid_parameters
  	xml_http_request :post, :create, :category => { :name => "Jennifer Hardware", :permalink => "jennifer-hardware" }
   assert_select_rjs :insert_html, :bottom, "category_list", :partial => "category_link"
    category_id = assigns(:category).id
    assert_select "li#category_#{category_id}"
  	assert_response :success
  end
  
  def test_javascript_should_fail_on_create_with_invalid_parameters
  	xml_http_request :post, :create, :category => { :name => "Plugins", :permalink => "plugins" }
   	assert_select_rjs :replace_html, "new_category_form"
    assert_response :success
  end

end
