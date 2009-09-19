require File.dirname(__FILE__) + '/../test_helper'
class CheatsheetsControllerTest  < ActionController::TestCase
  
  def test_truth; assert true; end
  
  def setup; @valid_cheatsheet_hash = Factory.attributes_for(:cheatsheet); end
 	
 	def test_1_should_succeed_on_create_with_valid_attributes
 	post :create, { :cheatsheet =>	@valid_cheatsheet_hash}, admin_pass
	assert assigns(:cheatsheet).valid?
	
 	assert_response :redirect
	assert_redirected_to cheatsheet_path(@valid_cheatsheet_hash[:permalink])
 	end

 	def test_2_should_fail_on_create_with_invalid_pdf
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash.merge(:pdf => fixture_file_upload("letterhead.png", "application/exe", :binary)) }, admin_pass
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:pdf_content_type]
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:pdf_content_type]
 		assert_template "new"
 	end
 	
 	def test_3_should_fail_on_create_with_invalid_permalink
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash.merge(:permalink => "a-bad&permalink") }, admin_pass
 		
 		assert_equal 1, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:permalink]
 		assert_template "new"
 	end 	
 	
 	def test_4_should_fail_on_create_with_blank_pdf 	
 		post :create, { :cheatsheet =>	@valid_cheatsheet_hash.merge(:pdf => "") }, admin_pass
 					
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
 		get :new, {}, admin_pass
		assert_response :success
 		assert_template "new"
 	end
 	
 	def test_7_should_fail_on_edit_without_administrator_logged_in
 		get :edit, { :id => 11 }
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_8_should_succeed_on_edit_with_administrator_logged_in
 		get :edit, { :id => Factory.create(:cheatsheet).id }, admin_pass
 		assert_response :success
 		assert_template "edit"
 	end
 	
 	def test_9_should_succeed_on_update_with_valid_attributes
 		post :update, { :id => Factory.create(:cheatsheet).id, :cheatsheet => @valid_cheatsheet_hash.merge(:permalink => "david-johnsons-smithers"), }, admin_pass
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_response :redirect
		assert_redirected_to cheatsheet_path("david-johnsons-smithers")
 	end
 	
 	def test_b_should_fail_on_update_with_invalid_attributes 		
 		invalid_cheatsheet_hash = @valid_cheatsheet_hash.merge(:permalink => "bad&perma*link", :pdf => fixture_file_upload("letterhead.png", "application/exe", :binary))		
 		post :update, { :id => Factory.create(:cheatsheet).id, :cheatsheet => invalid_cheatsheet_hash }, admin_pass

 		assert_equal 2, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:permalink]
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:pdf_content_type]
 		assert_equal "is invalid", assigns(:cheatsheet).errors[:pdf_content_type]
 		assert_response :success
		assert_template "edit"
 	end
 
end