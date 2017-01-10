require 'test_helper'

module LiveStudio
  class ChannelTest < ActiveSupport::TestCase
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
      @set_record_response_body = {
        code: 200,
        msg: '',
      }.to_json
      @get_record_video_list_body = {
        code: 200,
        msg: '',
        ret: {
          videoList: [
            {
              video_name: 'test_course_1',
              orig_video_key: 'test_video_key_1',
              uid: 'test_uid',
              vid: 1
            },
            {
              video_name: 'test_course_2',
              orig_video_key: 'test_video_key_2',
              uid: 'test_uid',
              vid: 2
            }
          ]
        }
      }.to_json
    end

    test 'update_video_list' do
      course = live_studio_courses(:course_without_channel)
      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      response_record = Typhoeus::Response.new(code: 200, body: @set_record_response_body)
      response_list = Typhoeus::Response.new(code: 200, body: @get_record_video_list_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/setAlwaysRecord').and_return(response_record)
      Typhoeus.stub('https://vcloud.163.com/app/videolist').and_return(response_list)
      channel = course.init_channel
      assert_difference 'channel.channel_videos.count', 2, '没有更新录播视频列表' do
        channel.set_always_recorded && channel.update_video_list
      end
      assert_equal ['test_course_1', 'test_course_2'], channel.channel_videos.map(&:name), '没有正确更新录播视频列表'
    end
  end
end
