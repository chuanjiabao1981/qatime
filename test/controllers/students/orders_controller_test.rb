require 'test_helper'

class Students::OrdersControllerTest < ActionController::TestCase
  setup do
    @students_order = students_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:students_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create students_order" do
    assert_difference('Students::Order.count') do
      post :create, students_order: { order_no: @students_order.order_no, product_id: @students_order.product_id }
    end

    assert_redirected_to students_order_path(assigns(:students_order))
  end

  test "should show students_order" do
    get :show, id: @students_order
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @students_order
    assert_response :success
  end

  test "should update students_order" do
    patch :update, id: @students_order, students_order: { order_no: @students_order.order_no, product_id: @students_order.product_id }
    assert_redirected_to students_order_path(assigns(:students_order))
  end

  test "should destroy students_order" do
    assert_difference('Students::Order.count', -1) do
      delete :destroy, id: @students_order
    end

    assert_redirected_to students_orders_path
  end
end
