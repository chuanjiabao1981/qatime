require 'test_helper'

class Workstation::SellersControllerTest < ActionController::TestCase
  setup do
    @workstation_seller = workstation_sellers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workstation_sellers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workstation_seller" do
    assert_difference('Workstation::Seller.count') do
      post :create, workstation_seller: {  }
    end

    assert_redirected_to workstation_seller_path(assigns(:workstation_seller))
  end

  test "should show workstation_seller" do
    get :show, id: @workstation_seller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workstation_seller
    assert_response :success
  end

  test "should update workstation_seller" do
    patch :update, id: @workstation_seller, workstation_seller: {  }
    assert_redirected_to workstation_seller_path(assigns(:workstation_seller))
  end

  test "should destroy workstation_seller" do
    assert_difference('Workstation::Seller.count', -1) do
      delete :destroy, id: @workstation_seller
    end

    assert_redirected_to workstation_sellers_path
  end
end
