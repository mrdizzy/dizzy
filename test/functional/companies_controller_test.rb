require File.dirname(__FILE__) + '/../test_helper'

class CompaniesControllerTest < ActionController::TestCase
	
  def test_truth
    assert true
  end
  
  # NEW
  
  def test_new_company
  	get :new, {}, { :admin_password => PASSWORD }
  	assert_response :success
  	assert_template "companies/new"
  end
  
  # CREATE
  
  def test_should_fail_new_company_without_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:business_card).id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:letterhead).id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:compliment_slip).id }, 	
  								}	
  					}, { :admin_password => PASSWORD }
  	assert_response :success
  	assert_template "companies/new"
  end

  def test_should_pass_new_company_with_valid_header_graphic
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:business_card).id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:header).id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:letterhead).id }, 	
  								}
  					}, { :admin_password => PASSWORD }
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
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:business_card).id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:letterhead).id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:header).id }, 	
  								}
  					}, { :admin_password => PASSWORD }
  		assert_response :success
  		assert_template "companies/new"
  end

  def test_should_fail_new_company_with_no_description
  		post :create, { 	:company => 
  								{ :name => "Minghella Ice Creams", :description => "" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:business_card).id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:letterhead).id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => portfolio_types(:header).id }, 	
  								}
  					}, { :admin_password => PASSWORD }
  		assert_response :success
  		assert_template "companies/new"
  end

end
