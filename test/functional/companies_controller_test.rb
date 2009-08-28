require File.dirname(__FILE__) + '/../test_helper'

class CompaniesControllerTest < ActionController::TestCase
	
  def test_truth
    assert true #
  end
  
  def setup
    @portfolio_type_1 = Factory(:portfolio_type)
	@portfolio_type_2 = Factory(:portfolio_type)
	@portfolio_type_3 = Factory(:portfolio_type)
	@portfolio_type_header = Factory(:portfolio_type_header)
  end
 
  # NEW
  
  def test_1_new_company
  	get :new, {}, { :admin_password => PASSWORD }
  	assert_response :success
  	assert_template "companies/new"
	savefile(@response.body)
  end
  
  def test_2_new_company_should_fail_when_not_logged_in
  	get :new
  	assert_redirected_to login_path
  end
  
  # CREATE
  
  def test_3_should_fail_new_company_without_header_graphic
	
  	post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company", :visible => 1 }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_3.id }, 	
  								}	
  					}, { :admin_password => PASSWORD }
					
	assert_equal 1, assigns(:company).errors.size, assigns(:company).errors.full_messages
	assert_equal ["Company must have a header graphic"], assigns(:company).errors.full_messages, "Company must have a header graphic"				
					
  	assert_response :success
  	assert_template "companies/new"
  end

  def test_3_should_pass_new_company_with_valid_header_graphic
	
  post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }, 	
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
  
  def test_4_should_fail_new_company_with_no_name

  		post :create, { 	:company => 
  								{ :name => "", :description => "Beautiful drinks company" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }, 	
  								}
  					}, { :admin_password => PASSWORD }
					
		assert_equal 1, assigns(:company).errors.size, assigns(:company).errors.full_messages
		assert_equal "can't be blank", assigns(:company).errors[:name], "Name should have error message"
  		assert_response :success
  		assert_template "companies/new"
  end

  def test_5_should_fail_new_company_with_no_description
  
  		post :create, { 	:company => 
  								{ :name => "Minghella Ice Creams", :description => "" }, 
  						:new_portfolio_items =>
  								{ "0" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								 "1" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								"2" =>
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }, 	
  								}
  					}, { :admin_password => PASSWORD }
		assert_equal 1, assigns(:company).errors.size, assigns(:company).errors.full_messages
		assert_equal "can't be blank", assigns(:company).errors[:description], "description can't be blank!"
  		assert_response :success
  		assert_template "companies/new"
  end

end
