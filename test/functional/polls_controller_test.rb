require File.dirname(__FILE__) + '/../test_helper'
require 'polls_controller'

# Re-raise errors caught by the controller.
class PollsController; def rescue_action(e) raise e end; end

class PollsControllerTest < Test::Unit::TestCase
  fixtures :polls

  def setup
    @controller = PollsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = polls(:first).id
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

    assert_not_nil assigns(:polls)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:poll)
    assert assigns(:poll).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:poll)
  end

  def test_create
    num_polls = Poll.count

    post :create, :poll => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_polls + 1, Poll.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:poll)
    assert assigns(:poll).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Poll.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Poll.find(@first_id)
    }
  end
end
