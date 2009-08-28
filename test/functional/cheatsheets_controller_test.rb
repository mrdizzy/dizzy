require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetsControllerTest  < ActionController::TestCase
  
  def test_truth
    assert true
  end
  
  def setup
  @valid_cheatsheet_hash = 	{ 	:permalink 		=> "action-two-mailer",
								"date(li)" 		=> "2008",
								"date(2i)" 		=> "8",
								"date(3i)" 		=> "1",
								"date(4i)" 		=> "14",
								"date(5i)" 		=> "24",
								:content		=> "Here is the content!",
								:title 			=> "ActionMailer",
								:category_ids 	=> [Factory(:category).id, Factory(:category).id, Factory(:category).id],
								:version_id 	=> Factory(:version).id,
								:description 	=> "Action Mailer cheatsheet",
								:new_version 	=> "",
								
								:binary_attributes => {
									:pdf 	=> { 
										:uploaded_data 	=> fixture_file_upload("letterhead.png", "application/pdf") 
									}
								} 
	 						}
  end
 	
 	def test_1_should_succeed_on_create_with_valid_attributes
 	post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
	assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 	
 	assert_response :redirect
	assert_redirected_to cheatsheet_path(@valid_cheatsheet_hash[:permalink])
 	end

 	def test_2_should_fail_on_create_with_invalid_pdf
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = fixture_file_upload("letterhead.png", "application/exe")

 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal "must be a PDF file", assigns(:cheatsheet).pdf.errors.on(:content_type)
 		assert_template "new"
 	end
 	
 	def test_3_should_fail_on_create_with_invalid_permalink
 		@valid_cheatsheet_hash[:permalink] = "a-bad&permalink!"

 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:permalink)
 		assert_template "new"
 	end 	
 	
 	def test_4_should_fail_on_create_with_blank_pdf
 		
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = ""
 	
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 					
 		assert assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_response :success
		assert_template "new"
 	end 	
 	
 	def test_5_should_fail_on_new_without_administrator_logged_in
 		get :new
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_6_should_succeed_on_new_with_administrator_logged_in
 		get :new, {}, { :admin_password => PASSWORD }
 		assert_response :success
 		assert_template "new"
 	end
 	
 	def test_7_should_fail_on_edit_without_administrator_logged_in
 		get :edit, { :id => 11 }
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_8_should_succeed_on_edit_with_administrator_logged_in
		cheatsheet = Factory(:cheatsheet, :pdf => Factory(:pdf))
		cheatsheet.save!
 		get :edit, { :id => cheatsheet.id }, { :admin_password => PASSWORD }
 		assert_response :success
 		assert_template "edit"
 	end
 	
 	def test_9_should_succeed_on_update_with_valid_attributes
		cheatsheet = Factory(:cheatsheet, :pdf => Factory(:pdf))
		cheatsheet.save!
		
 		post :update, { :id => cheatsheet.id, :cheatsheet => @valid_cheatsheet_hash, }, { :admin_password => PASSWORD }
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages 		
 		assert_equal 0, assigns(:cheatsheet).pdf.errors.size, assigns(:cheatsheet).pdf.errors.full_messages  		
 		assert_response :redirect
		assert_redirected_to cheatsheet_path("action-two-mailer")
 	end
 	
 	def test_b_should_fail_on_update_with_invalid_attributes
 		
 		@valid_cheatsheet_hash[:permalink] = "bad&perma*link"
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = fixture_file_upload("letterhead.png", "application/exe")
 		
		cheatsheet = Factory(:cheatsheet, :pdf => Factory(:pdf))
		cheatsheet.save!
		
 		post :update, { :id => cheatsheet.id, :cheatsheet => @valid_cheatsheet_hash }, { :admin_password => PASSWORD }

 		assert_equal 2, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:permalink)
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal "must be a PDF file", assigns(:cheatsheet).pdf.errors.on(:content_type)
 		assert_response :success
		assert_template "edit"
 	end
 
end