require 'test_helper'

module Exam
  class Station::PapersControllerTest < ActionController::TestCase
    setup do
      @station_paper = exam_station_papers(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:station_papers)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create station_paper" do
      assert_difference('Station::Paper.count') do
        post :create, station_paper: {  }
      end

      assert_redirected_to station_paper_path(assigns(:station_paper))
    end

    test "should show station_paper" do
      get :show, id: @station_paper
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @station_paper
      assert_response :success
    end

    test "should update station_paper" do
      patch :update, id: @station_paper, station_paper: {  }
      assert_redirected_to station_paper_path(assigns(:station_paper))
    end

    test "should destroy station_paper" do
      assert_difference('Station::Paper.count', -1) do
        delete :destroy, id: @station_paper
      end

      assert_redirected_to station_papers_path
    end
  end
end
