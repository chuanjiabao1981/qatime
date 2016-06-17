require 'test_helper'

class Managers::WaitersControllerTest < ActionController::TestCase
  setup do
    @managers_waiter = managers_waiters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:managers_waiters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create managers_waiter" do
    assert_difference('Managers::Waiter.count') do
      post :create, managers_waiter: { email: @managers_waiter.email, mobile: @managers_waiter.mobile, name: @managers_waiter.name, password: @managers_waiter.password, password_confirmation: @managers_waiter.password_confirmation }
    end

    assert_redirected_to managers_waiter_path(assigns(:managers_waiter))
  end

  test "should show managers_waiter" do
    get :show, id: @managers_waiter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @managers_waiter
    assert_response :success
  end

  test "should update managers_waiter" do
    patch :update, id: @managers_waiter, managers_waiter: { email: @managers_waiter.email, mobile: @managers_waiter.mobile, name: @managers_waiter.name, password: @managers_waiter.password, password_confirmation: @managers_waiter.password_confirmation }
    assert_redirected_to managers_waiter_path(assigns(:managers_waiter))
  end

  test "should destroy managers_waiter" do
    assert_difference('Managers::Waiter.count', -1) do
      delete :destroy, id: @managers_waiter
    end

    assert_redirected_to managers_waiters_path
  end
end
