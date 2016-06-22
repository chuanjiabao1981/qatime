require 'test_helper'

module LiveStudio
  class CourseTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    setup do
      @create_response_body1 = {
        "code": 200,
        "msg": '',
        "ret": {
          "cid": "bfca60cef2eb464fbf0f05c3fafacef1",
          "ctime": "rtmp://p2e95df8c.live.126.net/live/19419193f30441a",
          "pushUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044b",
          "httpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044c",
          "hlsPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044d",
          "rtmpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044e"
        }
      }.to_json

      @create_response_body2 = {
        "code": 200,
        "msg": '',
        "ret": {
          "cid": "bfca60cef2eb464fbf0f05c3fafacef2",
          "ctime": "rtmp://p2e95df8c.live.126.net/live/19419193f30441aa",
          "pushUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044bb",
          "httpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044cv",
          "hlsPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044dd",
          "rtmpPullUrl": "rtmp://p2e95df8c.live.126.net/live/19419193f3044ee"
        }
      }.to_json

      @delete_response_body = {
        "code": 200,
        "msg": "",
        "ret": {}
      }.to_json

    end

    test "course must has a teacher name or blank" do
      teacher = Teacher.find(users(:teacher1).id)
      course = live_studio_courses(:course_one)
      course.teacher = teacher
      assert_equal(teacher.name, course.teacher_name, "教师姓名不相符")

      course_no_teacher = live_studio_courses(:course_no_teacher)
      assert_nil(course_no_teacher.teacher_name, "教师姓名不为空")

      course_destroy_teacher = live_studio_courses(:course_destroy_teacher)
      assert_nil(course_destroy_teacher.teacher_name, "教师姓名不为空")
    end

    test "get order parmas" do
      course = live_studio_courses(:course_one)
      assert_equal([:total_money, :product], course.order_params.keys, "订单参数格式不对")
      assert_equal(course.price, course.order_params[:total_money], "订单金额不正确")
      assert_equal(course, course.order_params[:product], "购买错误商品")
    end

    test "initialize channel for course" do
      course = live_studio_courses(:course_without_channel)
      assert_difference('course.channels.count', 1, "channel 初始化失败") do
        course.init_channel
      end

      assert_no_difference('course.channels.count', "channel 重复初始化") do
        course.init_channel
      end
    end

    test "create channel streams for course" do
      course = live_studio_courses(:course_without_channel)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.get("https://vcloud.163.com/app/channel/create") == response

      channel = course.init_channel

      streams1 = channel.streams.first
      streams2 = channel.streams.last

      assert_equal("bfca60cef2eb464fbf0f05c3fafacef1", channel.remote_id, 'error')

      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044b", streams1.address, 'error')
      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044e", streams2.address, 'error')
    end

    test "sync channel streams for course" do
      course = live_studio_courses(:course_without_channel)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.get("https://vcloud.163.com/app/channel/create") == response

      channel = course.init_channel
      response = Typhoeus::Response.new(code: 200, body: @delete_response_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/delete').and_return(response)
      Typhoeus.get("https://vcloud.163.com/app/channel/delete") == response

      response = Typhoeus::Response.new(code: 200, body: @create_response_body2)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.get("https://vcloud.163.com/app/channel/create") == response

      channel.sync_streams

      streams1 = channel.streams.first
      streams2 = channel.streams.last
      assert_equal("bfca60cef2eb464fbf0f05c3fafacef2", channel.remote_id, 'error')

      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044bb", streams1.address, 'error')
      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044ee", streams2.address, 'error')
      end
  end
end
