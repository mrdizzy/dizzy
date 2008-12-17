require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetsControllerTest  < ActionController::TestCase
  
  fixtures :contents, :binaries, :categories, :versions
  
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
								:title 			=> "ActionMailer",
								:category_ids 	=> [categories(:cheatsheets).id],
								:version_id 	=> versions(:one).id,
								:description 	=> "Action Mailer cheatsheet",
								:new_version 	=> "",
								
								:binary_attributes => {
									:pdf 	=> { 
										:uploaded_data 	=> fixture_file_upload("letterhead.png", "application/pdf") 
									}, 															
									:thumbnail 	=> 	{ 
										:uploaded_data => fixture_file_upload("letterhead.png", "image/png") 
									}
								} 
	 						}
  end
 	
 	def test_should_succeed_on_create_with_valid_attributes
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		
 		assert_response :redirect
		assert_redirected_to cheatsheet_path(@valid_cheatsheet_hash[:permalink])
 	end

 	def test_should_fail_on_create_with_invalid_pdf
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = fixture_file_upload("letterhead.png", "application/exe")

 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal "must be a PDF file", assigns(:cheatsheet).pdf.errors.on(:content_type)
 		assert_template "new"
 	end
 	
 	def test_should_fail_on_create_with_invalid_permalink
 		@valid_cheatsheet_hash[:permalink] = "a-bad&permalink!"

 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:permalink)
 		assert_template "new"
 	end 	
 	
 	def test_should_fail_on_create_with_blank_thumbnail
 		
 		@valid_cheatsheet_hash[:binary_attributes][:thumbnail][:uploaded_data] = ""
 		
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 					
 		assert assigns(:cheatsheet).errors.on(:thumbnail)
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_response :success
		assert_template "new"
 	end 	
 
 	def test_should_fail_on_create_with_blank_pdf
 		
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = ""
 	
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, { :admin_password => PASSWORD }
 					
 		assert assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_response :success
		assert_template "new"
 	end 	
 	
 	def test_should_fail_on_new_without_administrator_logged_in
 		get :new
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_should_succeed_on_new_with_administrator_logged_in
 		get :new, {}, { :admin_password => PASSWORD }
 		assert_response :success
 		assert_template "new"
 	end
 	
 	def test_should_fail_on_edit_without_administrator_logged_in
 		get :edit, { :id => 11 }
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_should_succeed_on_edit_with_administrator_logged_in
 		get :edit, { :id => contents(:action_mailer_cheatsheet).id }, { :admin_password => PASSWORD }
 		assert_response :success
 		assert_template "edit"
 	end
 	
 	def test_should_succeed_on_update_with_valid_attributes
 		post :update, { :id => contents(:action_mailer_cheatsheet), :cheatsheet =>	@valid_cheatsheet_hash, }, { :admin_password => PASSWORD }
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages 		
 		assert_equal 0, assigns(:cheatsheet).pdf.errors.size, assigns(:cheatsheet).pdf.errors.full_messages  		
 		assert_equal 0, assigns(:cheatsheet).thumbnail.errors.size, assigns(:cheatsheet).thumbnail.errors.full_messages
 		assert_response :redirect
		assert_redirected_to cheatsheet_path("action-two-mailer")
 	end
 	
 	def test_should_fail_on_update_with_invalid_attributes
 		
 		@valid_cheatsheet_hash[:permalink] = "bad&perma*link"
 		@valid_cheatsheet_hash[:binary_attributes][:pdf][:uploaded_data] = fixture_file_upload("letterhead.png", "application/exe")
 		
 		post :update, { :id => contents(:action_mailer_cheatsheet).id, :cheatsheet => @valid_cheatsheet_hash }, { :admin_password => PASSWORD }

 		assert_equal 2, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:permalink)
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal "must be a PDF file", assigns(:cheatsheet).pdf.errors.on(:content_type)
 		assert_response :success
		assert_template "edit"
 	end
 
end