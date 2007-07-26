require File.dirname(__FILE__) + '/../test_helper'
require 'person_types_controller'

# Re-raise errors caught by the controller.
class PersonTypesController; def rescue_action(e) raise e end; end

class PersonTypesControllerTest < Test::Unit::TestCase
  fixtures :person_types

  def setup
    @controller = PersonTypesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = person_types(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:person_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:person_type)
    assert assigns(:person_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:person_type)
  end

  def test_create
    num_person_types = PersonType.count

    post :create, :person_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_person_types + 1, PersonType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:person_type)
    assert assigns(:person_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PersonType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PersonType.find(@first_id)
    }
  end
end
