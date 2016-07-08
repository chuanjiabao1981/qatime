require 'test_helper'

module Payment
  class ChangeRecordsControllerTest < ActionController::TestCase
    setup do
      @change_record = payment_change_records(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:change_records)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create change_record" do
      assert_difference('ChangeRecord.count') do
        post :create, change_record: {  }
      end

      assert_redirected_to change_record_path(assigns(:change_record))
    end

    test "should show change_record" do
      get :show, id: @change_record
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @change_record
      assert_response :success
    end

    test "should update change_record" do
      patch :update, id: @change_record, change_record: {  }
      assert_redirected_to change_record_path(assigns(:change_record))
    end

    test "should destroy change_record" do
      assert_difference('ChangeRecord.count', -1) do
        delete :destroy, id: @change_record
      end

      assert_redirected_to change_records_path
    end
  end
end
