require 'test_helper'

module LiveStudio
  class CourseTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    setup do
      @create_response_body1 = {
        code: 200,
        msg: '',
        ret: {
          cid: "bfca60cef2eb464fbf0f05c3fafacef1",
          ctime: "rtmp://p2e95df8c.live.126.net/live/19419193f30441a",
          pushUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044b",
          httpPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044c",
          hlsPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044d",
          rtmpPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044e"
        }
      }.to_json

      @create_response_body2 = {
        code: 200,
        msg: '',
        ret: {
          cid: "bfca60cef2eb464fbf0f05c3fafacef2",
          ctime: "rtmp://p2e95df8c.live.126.net/live/19419193f30441aa",
          pushUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044bb",
          httpPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044cv",
          hlsPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044dd",
          rtmpPullUrl: "rtmp://p2e95df8c.live.126.net/live/19419193f3044ee"
        }
      }.to_json

      @set_record_response_body = {
        code: 200,
        msg: '',
      }.to_json

      @delete_response_body = {
        code: 200,
        msg: "",
        ret: {}
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
      assert_equal([:amount, :product], course.order_params.keys, "订单参数格式不对")
      assert_equal(course.price, course.order_params[:amount], "订单金额不正确")
      assert_equal(course, course.order_params[:product], "购买错误商品")
    end

    test "initialize channel for course" do
      course = live_studio_courses(:course_without_channel)
      assert_difference('course.channels.count', 2, "channel 初始化失败") do
        course.init_channels
      end

      assert_no_difference('course.channels.count', "channel 重复初始化") do
        course.init_channels
      end
    end

    test "create channel streams for course" do
      course = live_studio_courses(:course_without_channel)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)

      channel = course.init_channels

      streams1 = channel.push_streams.first
      streams2 = channel.pull_streams.first

      assert_equal("bfca60cef2eb464fbf0f05c3fafacef1", channel.remote_id, '频道remote_id不正确')

      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044b", streams1.address, '推流地址不正确')
      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044e", streams2.address, 'rtmp拉流地址不正确')
    end

    test "create channel set record status" do
      course = live_studio_courses(:course_without_channel)
      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      response_record = Typhoeus::Response.new(code: 200, body: @set_record_response_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/setAlwaysRecord').and_return(response_record)

      channel = course.init_channels
      assert_equal true, channel.set_always_recorded, '频道未设置录制功能'
    end

    test "sync channel streams for course" do
      course = live_studio_courses(:course_without_channel)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)

      channel = course.init_channels
      response = Typhoeus::Response.new(code: 200, body: @delete_response_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/delete').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)

      response = Typhoeus::Response.new(code: 200, body: @create_response_body2)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)

      channel.sync_streams

      streams1 = channel.push_streams.first
      streams2 = channel.pull_streams.first
      assert_equal("bfca60cef2eb464fbf0f05c3fafacef2", channel.remote_id, '频道remote_id不正确')

      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044b", streams1.address, '推流地址不正确')
      assert_equal("rtmp://p2e95df8c.live.126.net/live/19419193f3044e", streams2.address, 'rtmp拉流地址不正确')
    end

    test "board push stream address" do
      course = live_studio_courses(:course_for_channel)
      assert_equal "board_push_stream_address", course.board_push_stream, "白板推流地址不正确"
    end

    test "board pull stream address" do
      course = live_studio_courses(:course_for_channel)
      assert_equal "board_pull_stream_address", course.board_pull_stream, "白板拉流地址不正确"
    end

    test "camera push stream address" do
      course = live_studio_courses(:course_for_channel)
      assert_equal "camera_push_stream_address", course.camera_push_stream, "摄像头推流地址不正确"
    end

    test "camera pull stream address" do
      course = live_studio_courses(:course_for_channel)
      assert_equal "camera_pull_stream_address", course.camera_pull_stream, "摄像头拉流地址不正确"
    end
  end
end
