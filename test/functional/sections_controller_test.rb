require File.dirname(__FILE__) + '/../test_helper'

class SectionsControllerTest < ActionController::TestCase

  fixtures :contents, :sections, :users

  def test_truth
    assert true
  end
 	
  def test_section_fixture
  	assert sections(:directory_structure)
  	assert contents(:action_mailer_cheatsheet)
  end
  
  def test_should_succeed_on_new
  	get :new, :cheatsheet_id => contents(:action_mailer_cheatsheet).permalink
  	
  	assert_select "form[action=/ruby_on_rails/cheatsheets/action-mailer/sections]"
  	assert_response :success
  	assert_template "new"
  end
  
  def test_should_succeed_on_edit
  	get :edit, :cheatsheet_id => contents(:action_mailer_cheatsheet).permalink, :id => sections(:database_mapping).id

	assert_select "form[action=/ruby_on_rails/cheatsheets/action-mailer/sections/#{sections(:database_mapping).id}]"
	assert_response :success
	assert_template "edit"
  end

  def test_should_succeed_on_create_with_valid_parameters
  	post :create, { :section => 	{ 	:body => "Here is some body text",
  										:content_id => contents(:action_mailer_cheatsheet).id,
  										:title => "Section title",
					  					:summary => "A brief summary",
					  					:permalink => "a-unique-and-valid-permalink-for-sections"}
				 }
					  					
  	assert_equal 0, assigns(:section).errors.size, assigns(:section).errors.full_messages
  	assert_redirected_to cheatsheet_section_path(content(:action_mailer_cheatsheet).id, assigns(:section).permalink)
  end

  def test_should_fail_on_create_with_invalid_content_id
  	post :create, { :section => 	{ 	:body => "Here is some body text",
  										:content_id => 154,
  										:title => "Section title",
					  					:summary => "A brief summary",
					  					:permalink => "a-unique-and-valid-permalink-for-sections"}
				 }
					  					
  	assert_equal 1, assigns(:section).errors.size, assigns(:section).errors.full_messages
  	assert_equal "does not exist", assigns(:section).errors.on(:content)
  	assert_template "new"
  end

  def test_should_fail_on_create_with_empty_parameters
  	post :create, { :section => 	{ :content_id => "" },
					  :cheatsheet_id => "rails-migrations"
				 }
					  					
  	assert_equal "does not exist", assigns(:section).errors.on(:content)
  	assert_equal "can't be blank", assigns(:section).errors.on(:permalink)
    assert_equal "can't be blank", assigns(:section).errors.on(:title)
    assert_equal "can't be blank", assigns(:section).errors.on(:summary)
   end  

  def test_should_succeed_on_destroy_with_valid_parameters
  	sections = Section.find(:all)
  	size_before_delete = sections.size
  	delete :destroy, { :cheatsheet_id => contents(:action_mailer_cheatsheet).permalink, :id => sections(:database_mapping).id }
  	assert_redirected_to edit_cheatsheet_path(contents(:action_mailer_cheatsheet).id)
  	assert_equal size_before_delete - 1, Section.find(:all).size
  end

end