require File.dirname(__FILE__) + '/../test_helper'
require 'portfolio_type_admin_controller'

# Re-raise errors caught by the controller.
class PortfolioTypeAdminController; def rescue_action(e) raise e end; end

class PortfolioTypeAdminControllerTest < Test::Unit::TestCase
  fixtures :portfolio_types

  def setup
    @controller = PortfolioTypeAdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = portfolio_types(:first).id
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

    assert_not_nil assigns(:portfolio_types)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:portfolio_type)
    assert assigns(:portfolio_type).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:portfolio_type)
  end

  def test_create
    num_portfolio_types = PortfolioType.count

    post :create, :portfolio_type => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_portfolio_types + 1, PortfolioType.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:portfolio_type)
    assert assigns(:portfolio_type).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      PortfolioType.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PortfolioType.find(@first_id)
    }
  end
end
