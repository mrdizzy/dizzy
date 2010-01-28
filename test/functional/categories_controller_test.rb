require File.dirname(__FILE__) + '/../test_helper'

class CategoriesControllerTest < ActionController::TestCase
  
  def setup
    cheatsheet_latest = Factory(:cheatsheet, :date => Time.now)
    cheatsheet_middle = Factory(:article, :date => 5.days.ago)
    cheatsheet_oldest = Factory(:cheatsheet, :date => 10.days.ago)
    @main_category = Factory(:category, :contents => [cheatsheet_latest, cheatsheet_middle, cheatsheet_oldest])
  end

  def test_truth() assert true   end
  
  def test_1_should_succeed_on_show_with_valid_permalink
  	get :show, :id => @main_category.permalink

  	assert_response :success
  	assert_select "span.destination", { :count => 1, :text => @main_category.name }
    assert_select "h2", { :count => 1, :text => @main_category.contents[0].title }
    assert_select "h2", { :count => 1, :text => @main_category.contents[1].title }
    assert_select "h2", { :count => 1, :text => @main_category.contents[2].title }
  	assert_template("show")
  end
    
  def test_2_rjs_should_succeed_on_destroy_with_valid_id
  	assert_difference('Category.count', -1) do
  		xml_http_request :delete, :destroy, { :id => @main_category.id }, { :admin_password => PASSWORD }
    end
  	assert_select_rjs :replace_html, "category_#{@main_category.id}", "<del>#{@main_category.name}</del>"
  	assert_response :success
  end
  
  def test_3_rjs_should_fail_on_destroy_when_not_logged_in
  	assert_difference('Category.count', 0) do
  		xhr :delete, :destroy, :id => @main_category.id
    end
  end  
  
  def test_4_rjs_should_succeed_on_create_with_valid_parameters
  	assert_difference('Category.count') do
  		xhr :post, :create, { :category => { :name => "Jennifer Hardware", :permalink => "jennifer-hardware" } }, { :admin_password => PASSWORD }
    end
    assert_select_rjs :insert_html, :bottom, "category_list", :partial => "category_link"
    category_id = assigns(:category).id
    assert_select "li#category_#{category_id}"
  	assert_response :success
  end
  
  def test_5_rjs_should_fail_on_create_when_not_logged_in
  	  assert_difference('Category.count', 0) do
  		xhr :post, :create, { :category => { :name => "Melanie Hardware", :permalink => "melanie-hardware" } }
    end
  end
  
  def test_6_rjs_should_fail_on_create_with_duplicate_permalink
    xhr :post, :create, { :category => { :name => "Files", :permalink => @main_category.permalink } }, { :admin_password => PASSWORD }
    savefile(@response.body)
    assert_template("new")
    assert_select_rjs 
    #assert_select "p+ul>li", { :count => 1, :text => "Permalink has already been taken"}, "Should have found error on permalink"
    #assert_select "div>h2", {:count => 1, :text => "1 error prohibited this category from being saved" }, "Should have found 1 error"
      
    assert_response :success
  end
  
  def test_7_rjs_should_fail_on_create_with_duplicate_name
    xhr :post, :create, { :category => { :name => @main_category.name, :permalink => "file-handling-new" } }, { :admin_password => PASSWORD }
    assert_select_rjs :replace_html, "new_category_form"
    assert_select "ul>li:nth-of-type(1)", { :count => 1, :text => "Name has already been taken"}, "Should have found error on name"
    assert_select "div>h2", {:count => 1, :text => "1 error prohibited this category from being saved" }, "Should have found 1 error"
    assert_template("new")
    assert_response :success        
  end
  

end
