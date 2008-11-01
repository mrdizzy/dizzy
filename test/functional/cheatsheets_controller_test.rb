require File.dirname(__FILE__) + '/../test_helper'

class CheatsheetsControllerTest  < ActionController::TestCase
  
  fixtures :contents, :users, :binaries, :categories, :sections, :versions
  
  def test_truth
    assert true
  end
 	
 	def test_should_succeed_on_create_with_valid_attributes
 		post :create, { 
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => [categories(:cheatsheets).id],
 										  :version_id => versions(:one).id,
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "",:binary_attributes => {
 						:pdf => { :uploaded_data => fixture_file_upload("letterhead.png", "application/pdf") }, :thumbnail 	=> 	{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png") }} }
 					}, { :administrator_id => users(:mr_dizzy).id }
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages	
 		
 		assert_response :redirect
		assert_redirected_to cheatsheets_path
 	end
 	
 	def test_should_fail_on_create_without_thumbnail
 		post :create, { :cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => [categories(:cheatsheets),categories(:action_mailer)],
 										  :version_id => versions(:one).id,
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "",
 										  :binary_attributes => { 
 										    :thumbnail => { :uploaded_data => "" },
 										  	:pdf =>  { :uploaded_data => fixture_file_upload("letterhead.png", "application/pdf") }
 										  }
 										   }
 					}, { :administrator_id => users(:mr_dizzy).id }
 					
 		assert assigns(:cheatsheet).errors.on(:thumbnail)
 		assert_equal 1, assigns(:cheatsheet).errors.size, "Should be 1 error on cheatsheet"
 		assert_response :success
		assert_template "new"
 	end 	
 
 	def test_should_fail_on_create_without_pdf
 		post :create, { :cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => [categories(:cheatsheets),categories(:action_mailer)],
 										  :version_id => versions(:one).id,
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "",
 										  :binary_attributes => { 
 										    :pdf => { :uploaded_data => "" },
 										  	:thumbnail =>  { :uploaded_data => fixture_file_upload("letterhead.png", "image/png") }
 										  }
 										 }
 					}, { :administrator_id => users(:mr_dizzy).id }
 					
 		assert assigns(:cheatsheet).errors.on(:pdf)
 		assert_equal 1, assigns(:cheatsheet).errors.size, "Should be 1 error on cheatsheet"
 		assert_response :success
		assert_template "new"
 	end 	
 	
 	def test_should_fail_on_new_without_administrator
 		get :new
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_should_succeed_on_new_with_administrator
 		get :new, {}, { :administrator_id => users(:mr_dizzy).id }
 		assert_response :success
 		assert_template "new"
 	end
 	
 	def test_should_fail_on_edit_without_administrator
 		get :edit, { :id => 11 }
 		assert_response :redirect
 		assert_redirected_to login_path
 	end
 	
 	def test_should_succeed_on_edit_with_administrator
 		get :edit, { :id => contents(:action_mailer_cheatsheet).id }, { :administrator_id => users(:mr_dizzy).id }
 		assert_response :success
 		assert_template "edit"
 	end
 	
 	def test_should_succeed_on_update_with_valid_attributes
 		post :update, { :id => contents(:action_mailer_cheatsheet), 
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => [categories(:cheatsheets),categories(:action_mailer)],
 										  :version_id => versions(:one).id,
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "" }
 					}, { :administrator_id => users(:mr_dizzy).id }
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages 		
 		assert_equal 0, assigns(:cheatsheet).pdf.errors.size, assigns(:cheatsheet).pdf.errors.full_messages  		
 		assert_equal 0, assigns(:cheatsheet).thumbnail.errors.size, assigns(:cheatsheet).thumbnail.errors.full_messages
 		assert_response :redirect
		assert_redirected_to cheatsheet_path("action-two-mailer")
 	end
 	
 	def test_should_fail_on_update_with_invalid_attributes
 		post :update, { :id => contents(:action_mailer_cheatsheet).id, 
 						:cheatsheet =>	{ :permalink => "action-two-mailer^%",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => [categories(:cheatsheets),categories(:action_mailer)],
 										  :version_id => versions(:one).id,
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "", 
 										  :binary_attributes => {
 												:pdf => { :uploaded_data => fixture_file_upload("letterhead.png", "application/andf") }, 																:thumbnail 	=> 	{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png") } 
 										   } 
 							}
 					}, { :administrator_id => users(:mr_dizzy).id }

 		assert_equal 2, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:permalink)
 		assert_equal "is invalid", assigns(:cheatsheet).errors.on(:pdf)
 		assert_response :success
		assert_template "edit"
 	end
end