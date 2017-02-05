require 'test_helper'

class Workstation::WorkstationsControllerTest < ActionController::TestCase
  setup do
    @workstation_workstation = workstation_workstations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workstation_workstations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workstation_workstation" do
    assert_difference('Workstation::Workstation.count') do
      post :create, workstation_workstation: {  }
    end

    assert_redirected_to workstation_workstation_path(assigns(:workstation_workstation))
  end

  test "should show workstation_workstation" do
    get :show, id: @workstation_workstation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workstation_workstation
    assert_response :success
  end

  test "should update workstation_workstation" do
    patch :update, id: @workstation_workstation, workstation_workstation: {  }
    assert_redirected_to workstation_workstation_path(assigns(:workstation_workstation))
  end

  test "should destroy workstation_workstation" do
    assert_difference('Workstation::Workstation.count', -1) do
      delete :destroy, id: @workstation_workstation
    end

    assert_redirected_to workstation_workstations_path
  end
end
