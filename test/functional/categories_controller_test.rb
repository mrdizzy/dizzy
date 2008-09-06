require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase
	
	fixtures :categories
	
  def setup
    @main_category = categories(:file_handling)
  end

  def test_truth
    assert true
  end
  
  def test_should_succeed_on_show_with_valid_permalink
  	get :show, :id => @main_category.permalink
  	assert_response :success
  	assert_select "h1", { :count => 1, :text => @main_category.name }
  	assert_template("show")
  end
    
  def test_rjs_should_succeed_on_destroy_with_valid_id
  	xml_http_request :delete, :destroy, :id => @main_category.id
  	assert_select_rjs :replace_html, "category_#{@main_category.id}", "<del>#{@main_category.name}</del>"
  	assert_template("destroy")
  	assert_response :success
  end
  
  def test_rjs_should_succeed_on_create_with_valid_parameters
  	xml_http_request :post, :create, :category => { :name => "Jennifer Hardware", :permalink => "jennifer-hardware" }
   assert_select_rjs :insert_html, :bottom, "category_list", :partial => "category_link"
    category_id = assigns(:category).id
    assert_select "li#category_#{category_id}"
    assert_template("create")
  	assert_response :success
  end
  
  def test_rjs_should_fail_on_create_with_duplicate_parameters
    	# Permalink only    
    xml_http_request :post, :create, :category => { :name => "Files", :permalink => "file-handling" }
    assert_select_rjs :replace_html, "new_category_form"    
    assert_select "p+ul>li", { :count => 1, :text => "Permalink has already been taken"}, "Should have found error on permalink"
    assert_select "div>h2", {:count => 1, :text => "1 error prohibited this category from being saved" }, "Should have found 1 error"
    assert_template("new")
    assert_response :success
    
       	# Name only    
    xml_http_request :post, :create, :category => { :name => "File handling", :permalink => "file-handling-new" }
    assert_select_rjs :replace_html, "new_category_form"
    assert_select "ul>li:nth-of-type(1)", { :count => 1, :text => "Name has already been taken"}, "Should have found error on name"
    assert_select "div>h2", {:count => 1, :text => "1 error prohibited this category from being saved" }, "Should have found 1 error"
    assert_template("new")
    assert_response :success
        
  end

end
