require 'test_helper'

module Exam
  class Station::GroupTopicsControllerTest < ActionController::TestCase
    setup do
      @station_group_topic = exam_station_group_topics(:one)
      @routes = Engine.routes
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:station_group_topics)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create station_group_topic" do
      assert_difference('Station::GroupTopic.count') do
        post :create, station_group_topic: {  }
      end

      assert_redirected_to station_group_topic_path(assigns(:station_group_topic))
    end

    test "should show station_group_topic" do
      get :show, id: @station_group_topic
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @station_group_topic
      assert_response :success
    end

    test "should update station_group_topic" do
      patch :update, id: @station_group_topic, station_group_topic: {  }
      assert_redirected_to station_group_topic_path(assigns(:station_group_topic))
    end

    test "should destroy station_group_topic" do
      assert_difference('Station::GroupTopic.count', -1) do
        delete :destroy, id: @station_group_topic
      end

      assert_redirected_to station_group_topics_path
    end
  end
end
