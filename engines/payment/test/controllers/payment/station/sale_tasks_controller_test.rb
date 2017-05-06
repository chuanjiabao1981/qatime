require 'test_helper'

module Payment
  class SaleTasksControllerTest < ActionController::TestCase
    setup do
      @sale_task = payment_sale_tasks(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:sale_tasks)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create sale_task" do
      assert_difference('SaleTask.count') do
        post :create, sale_task: {  }
      end

      assert_redirected_to sale_task_path(assigns(:sale_task))
    end

    test "should show sale_task" do
      get :show, id: @sale_task
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @sale_task
      assert_response :success
    end

    test "should update sale_task" do
      patch :update, id: @sale_task, sale_task: {  }
      assert_redirected_to sale_task_path(assigns(:sale_task))
    end

    test "should destroy sale_task" do
      assert_difference('SaleTask.count', -1) do
        delete :destroy, id: @sale_task
      end

      assert_redirected_to sale_tasks_path
    end
  end
end
