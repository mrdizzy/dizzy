require File.dirname(__FILE__) + '/../test_helper'

class CompaniesControllerTest < ActionController::TestCase
	
  def test_truth
    assert true 
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
    assert_select "form[id=new_company]" do 
        assert_select "input[value=put]", :count => 0
    end
    assert_select "form[enctype='multipart/form-data']"
    assert_select "form[action='#{companies_path}']"
    
    savefile(@response.body)
  	assert_template "companies/edit"
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
  	assert_template "companies/edit"
  end

  def test_4_should_pass_new_company_with_valid_header_graphic
	
  post :create, { 	:company => 
  								{ :name => "Pepsi Cola", :description => "Beautiful drinks company", 
  						:new_portfolio_items =>
  								[
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }	
  								]
                     }
  					}, { :admin_password => PASSWORD }
   company = Company.find_by_name("Pepsi Cola")
   assert company, "Company must exist"
   
   company.portfolio_items.each do |item|
      assert_equal item.data, fixture_file_upload("letterhead.png", "image/png").read
   end
   
  	assert_redirected_to companies_path
 
  end
  
  def test_5_should_fail_new_company_with_no_name

  		post :create, { 	:company => 
  								{ :name => "", :description => "Beautiful drinks company",
  						:new_portfolio_items =>
  								[
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }, 	
  								]
                        }
  					}, { :admin_password => PASSWORD }
					
		assert_equal 1, assigns(:company).errors.size, assigns(:company).errors.full_messages
		assert_equal "can't be blank", assigns(:company).errors[:name], "Name should have error message"
  		assert_response :success
  		assert_template "companies/edit"
  end

  def test_6_should_fail_new_company_with_no_description
  
  		post :create, { 	:company => 
  								{ :name => "Minghella Ice Creams", :description => "",
  						:new_portfolio_items =>
  								[
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id }, 
  								 
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id }, 	
  								
  										{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id }, 	
  								]
                       }
  					}, { :admin_password => PASSWORD }
		assert_equal 1, assigns(:company).errors.size, assigns(:company).errors.full_messages
		assert_equal "can't be blank", assigns(:company).errors[:description], "description can't be blank!"
  		assert_response :success
  		assert_template "companies/edit"
  end
  
  # EDIT
  
  def test_7_should_fail_on_edit_when_not_logged_in
   company = Factory(:company, :portfolio_items => [ Factory(:portfolio_item), Factory(:portfolio_item), Factory(:portfolio_item, :portfolio_type => @portfolio_type_header)] )
  
   post :edit, { :id => company.id }, { }
   assert_redirected_to login_path
  end
  
  def test_8_should_succeed_on_edit_when_logged_in
   company = Factory(:company, :portfolio_items => [ Factory(:portfolio_item), Factory(:portfolio_item), Factory(:portfolio_item, :portfolio_type => @portfolio_type_header)] )
   
   post :edit, { :id => company.id }, { :admin_password => PASSWORD}
   
   assert_response :success  
   assert_select "h1", :text => "Heavenly Chocolate Fountains"
   assert_select "form[enctype=multipart/form-data]"
   assert_select "form[action=/companies/#{company.id}]"
   assert_select "form[id=edit_company_#{company.id}]" do
    assert_select "input[value=put]"
   end
  
    company.portfolio_items.each do |item| 
      assert_select "div#portfolio_item_#{item.id}" 
      assert_select "img[src='#{portfolio_item_path(item,:png)}']"
    end 
   
 end
 
 def test_9_should_succeed_on_update
    portfolio_item_a = Factory(:portfolio_item)
    portfolio_item_b = Factory(:portfolio_item)
    portfolio_item_c = Factory(:portfolio_item, :portfolio_type => @portfolio_type_header)
 
   company = Factory(:company, :portfolio_items => [ portfolio_item_a, portfolio_item_b, portfolio_item_c] )
 
   post :update, { 	:id => company.id, 
                     :company =>
  								{ :name => "An updated company!", :description => "An updated description!",
  						:portfolio_items_attributes =>
                     {  portfolio_item_a.id.to_s =>
  								
  										{ :uploaded_data => fixture_file_upload("compliment.png", "image/png"), :portfolio_type_id => @portfolio_type_1.id, :id => portfolio_item_a.id.to_s}, 
                        portfolio_item_b.id.to_s =>
  								
  										{ :uploaded_data => fixture_file_upload("compliment.png", "image/png"), :portfolio_type_id => @portfolio_type_2.id, :id => portfolio_item_b.id.to_s }, 	
  								portfolio_item_c.id.to_s =>
  										{ :uploaded_data => fixture_file_upload("compliment.png", "image/png"), :portfolio_type_id => @portfolio_type_header.id, :id => portfolio_item_c.id.to_s  }, 	
  								}
                       }
  					}, { :admin_password => PASSWORD }

		assert_equal 0, assigns(:company).errors.size, assigns(:company).errors.full_messages
		assert_equal assigns(:company).name, "An updated company!", "Name should have been updated!"
    assert_equal assigns(:company).description, "An updated description!", "Description should have been updated!"  

   company = Company.find(company.id)
   assert company, "Company must exist"
      
      company.portfolio_items.each do |item|      
         assert_equal item.data, fixture_file_upload("compliment.png", "image/png").read
      end
      
      assert_redirected_to companies_path
 
 end
 
end
