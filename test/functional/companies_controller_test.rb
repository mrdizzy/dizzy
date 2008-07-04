require File.dirname(__FILE__) + '/../test_helper'
require 'companies_controller'

# Re-raise errors caught by the controller.
class CompaniesController; def rescue_action(e) raise e end; end

class CompaniesControllerTest < Test::Unit::TestCase
	
	fixtures :companies
	fixtures :portfolio_types
	fixtures :portfolio_items

  def setup
    @controller = CompaniesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
  
  # New company
  
  def test_new_company
  	get :new
  	assert_response :success
  	assert_template "companies/new"
  end
  
  def test_should_fail_new_company_without_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 1 } 
  								}		
  					}
  	assert_response :success
  	assert_template "companies/new"
  end

  def test_should_pass_new_company_with_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 7 } 
  								}		
  					}
  	assert_redirected_to companies_path
  end

end
