require File.dirname(__FILE__) + '/../test_helper'
require 'portfolio_admin_controller'

# Re-raise errors caught by the controller.
class PortfolioAdminController; def rescue_action(e) raise e end; end

class PortfolioAdminControllerTest < Test::Unit::TestCase
  fixtures :portfolio_items

  def setup
    @controller = PortfolioAdminController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
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

    assert_not_nil assigns(:portfolio_items)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:portfolio_item)
    assert assigns(:portfolio_item).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:portfolio_item)
  end

  def test_create
    num_portfolio_items = PortfolioItem.count

    post :create, :portfolio_item => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_portfolio_items + 1, PortfolioItem.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:portfolio_item)
    assert assigns(:portfolio_item).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil PortfolioItem.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      PortfolioItem.find(1)
    }
  end
end
