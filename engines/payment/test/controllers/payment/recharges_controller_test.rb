require 'test_helper'

module Payment
  class RechargesControllerTest < ActionController::TestCase
    setup do
      @recharge = payment_recharges(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:recharges)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create recharge" do
      assert_difference('Recharge.count') do
        post :create, recharge: { amount: @recharge.amount, created_at: @recharge.created_at, status: @recharge.status }
      end

      assert_redirected_to recharge_path(assigns(:recharge))
    end

    test "should show recharge" do
      get :show, id: @recharge
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @recharge
      assert_response :success
    end

    test "should update recharge" do
      patch :update, id: @recharge, recharge: { amount: @recharge.amount, created_at: @recharge.created_at, status: @recharge.status }
      assert_redirected_to recharge_path(assigns(:recharge))
    end

    test "should destroy recharge" do
      assert_difference('Recharge.count', -1) do
        delete :destroy, id: @recharge
      end

      assert_redirected_to recharges_path
    end
  end
end
