require File.dirname(__FILE__) + '/../test_helper'

class PortfolioItemsControllerTest < ActionController::TestCase

  def test_truth
    assert true
  end
  
  def pass
    @pass ||= { :admin_password => PASSWORD }
  end
  
  # EDIT
  
  def test_1_edit_portfolio_item_should_succeed
    item = Factory(:portfolio_item)
    
    xhr(:get, :edit, { :id => item.id }, pass )
    assert_select_rjs :insert_html, :bottom, "portfolio_item_#{item.id}", :partial => "edit"
    assert_template "_edit"
    
    assert_select "input[name='company[existing_portfolio_items][#{item.id}][uploaded_data]']"    
    assert_select "select[name='company[existing_portfolio_items][#{item.id}][portfolio_type_id]']"
    assert_response :success
  end

  def test_2_edit_portfolio_item_should_fail
    item = Factory(:portfolio_item)
    
    xhr(:get, :edit, { :id => item.id })
    assert_redirected_to login_path
    # TODO: Handle RJS when not logged into admin
  end
  
  # NEW
  
  def test_3_new_portfolio_item_should_succeed
    xhr(:get, :new, {}, pass )
    assert_select_rjs :insert_html, :top, "new_items", :partial => "new"
    assert_select "input[name='company[new_portfolio_items][][uploaded_data]']"    
    assert_select "select[name='company[new_portfolio_items][][portfolio_type_id]']"
    assert_template "_edit"
    assert_response :success
  end

end