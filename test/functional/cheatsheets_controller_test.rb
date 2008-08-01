require File.dirname(__FILE__) + '/../test_helper'
require 'cheatsheets_controller'

# Re-raise errors caught by the controller.
class CheatsheetsController; def rescue_action(e) raise e end; end

class CheatsheetsControllerTest < Test::Unit::TestCase
	
	fixtures :contents
	fixtures :users
	fixtures :binaries
	fixtures :categories
	fixtures :versions
	fixtures :categories_contents
	fixtures :comments

  def setup
    @controller = CheatsheetsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
 	
 	def test_should_create_on_valid_attributes
 		post :create, { :thumbnail 	=> 	{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png") },
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => ["2"],
 										  :version_id => "1",
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "" },
 						:pdf => { :uploaded_data => fixture_file_upload("letterhead.png", "image/pdf") } 
 					}, { :administrator_id => users(:mr_dizzy).id }
 					
 		assert_response :redirect
		assert_redirected_to cheatsheets_path
 	end
 	
 	def test_should_fail_on_create_without_thumbnail
 		post :create, { :thumbnail 	=> 	{ :uploaded_data => "" },
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => ["2"],
 										  :version_id => "1",
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "" },
 						:pdf => { :uploaded_data => fixture_file_upload("letterhead.png", "image/pdf") } 
 					}, { :administrator_id => users(:mr_dizzy).id }
 					
 		assert assigns(:cheatsheet).errors.on(:thumbnail)
 		assert_response :success
		assert_template "new"
 	end 	
 
 
 	def test_should_fail_on_create_without_pdf
 		post :create, { :thumbnail 	=> 	{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png")  },
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => ["2"],
 										  :version_id => "1",
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "" },
 						:pdf => { :uploaded_data => "" } 
 					}, { :administrator_id => users(:mr_dizzy).id }
 					
 		assert assigns(:cheatsheet).errors.on(:pdf)
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
 		get :edit, { :id => 11 }, { :administrator_id => users(:mr_dizzy).id }
 		assert_equal 11, assigns(:cheatsheet).id
 		assert_response :success
 		assert_template "edit"
 	end
 	
 	def test_should_succeed_on_update_with_valid_attributes
 		post :update, { :id => "11", 
 						:thumbnail 	=> 	{ :uploaded_data => fixture_file_upload("letterhead.png", "image/png") },
 						:cheatsheet =>	{ :permalink => "action-two-mailer",
 										  "date(li)" => "2008",
 										  "date(2i)" => "8",
 										  "date(3i)" => "1",
 										  "date(4i)" => "14",
 										  "date(5i)" => "24",
 										  :title => "ActionMailer",
 										  :category_ids => ["2"],
 										  :version_id => "1",
 										  :description => "Action Mailer cheatsheet",
 										  :new_version => "" },
 						:pdf => { :uploaded_data => fixture_file_upload("letterhead.png", "application/pdf") } 
 					}, { :administrator_id => users(:mr_dizzy).id }
 		
 		assert_equal 0, assigns(:cheatsheet).errors.size, assigns(:cheatsheet).errors.full_messages
 		
 		assert_equal 0, assigns(:cheatsheet).pdf.errors.size, assigns(:cheatsheet).pdf.errors.full_messages 
 		
 		assert_equal 0, assigns(:cheatsheet).thumbnail.errors.size, assigns(:cheatsheet).thumbnail.errors.full_messages
 		assert_response :redirect
		assert_redirected_to cheatsheet_path("action-two-mailer")
 	end
 	
end