require 'test_helper'

class Managers::SellersControllerTest < ActionController::TestCase
  setup do
    @managers_seller = managers_sellers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:managers_sellers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create managers_seller" do
    assert_difference('Managers::Seller.count') do
      post :create, managers_seller: { email: @managers_seller.email, mobile: @managers_seller.mobile, name: @managers_seller.name, password: @managers_seller.password, password_confirmation: @managers_seller.password_confirmation }
    end

    assert_redirected_to managers_seller_path(assigns(:managers_seller))
  end

  test "should show managers_seller" do
    get :show, id: @managers_seller
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @managers_seller
    assert_response :success
  end

  test "should update managers_seller" do
    patch :update, id: @managers_seller, managers_seller: { email: @managers_seller.email, mobile: @managers_seller.mobile, name: @managers_seller.name, password: @managers_seller.password, password_confirmation: @managers_seller.password_confirmation }
    assert_redirected_to managers_seller_path(assigns(:managers_seller))
  end

  test "should destroy managers_seller" do
    assert_difference('Managers::Seller.count', -1) do
      delete :destroy, id: @managers_seller
    end

    assert_redirected_to managers_sellers_path
  end
end
