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
  
  # NEW
  
  def test_new_company
  	get :new
  	assert_response :success
  	assert_template "companies/new"
  end
  
  # CREATE
  
  def test_should_fail_new_company_without_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 1 }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 6 }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 3 }, 	
  								}	
  					}
  	assert_response :success
  	assert_template "companies/new"
  end

  def test_should_pass_new_company_with_valid_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 7 }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 6 }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 3 }, 	
  								}
  					}
  	assert_redirected_to companies_path
  	follow_redirect
  	assert_template "companies/index"
  	companies = Company.find(:all)
  	companies.each do |company|
  		assert_select "tr#company_#{company.id}" do 
  			assert_select "td", /#{company.name}/
  			assert_select "td", company.description
  		end
  	end
  end
  
  def test_should_fail_new_company_with_no_name
  		post :create, { 	:company => 
  								{ :name => "", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 7 }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 6 }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 3 }, 	
  								}
  					}
  		assert_response :success
  		assert_template "companies/new"
  end

  def test_should_fail_new_company_with_no_description
  		post :create, { 	:company => 
  								{ :name => "Minghella Ice Creams", :description => "" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 7 }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 6 }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => 3 }, 	
  								}
  					}
  		assert_response :success
  		assert_template "companies/new"
  end

end
