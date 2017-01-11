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
      @get_video_info_body = {
        code: 200,
        ret: {
          createTime: 1466578358729,
          origUrl: "http://vodk32ywxdf.vod.126.net/vodk32ywxdf/44d30332-7402-4b2f-82c8-154dbb6b4e14.mp4",
          downloadOrigUrl: "http://vodk32ywxdf.nosdn.127.net/44d30332-7402-4b2f-82c8-154dbb6b4e14.mp4?NOSAccessKeyId=ab1856bb39044591939d7b94e1b8e5ee&Expires=1498558005&download=watermark_test_1.mp4&Signature=+Gu+vgiUP1rL4pbx+52GH4QCo/OHAtlhgzCzPV9f0vc=",
          shdMp4Url: "http://vodk32ywxdf.vod.126.net/vodk32ywxdf/nos/mp4/2016/06/22/v32_shd.mp4",
          sdMp4Size: 17906823,
          videoName: "watermark_test_1",
          downloadSdMp4Url: "http://vodk32ywxdf.nosdn.127.net/nos/mp4/2016/06/22/v32_sd.mp4?NOSAccessKeyId=ab1856bb39044591939d7b94e1b8e5ee&Expires=1498558006&download=%E6%A0%87%E6%B8%85_watermark_test_1.mp4&Signature=64FOWYzLciWyTe8hmLMRVCYRCsQLbEOWtNqcB9rUj18=",
          description: nil,
          hdMp4Size: 25227850,
          downloadSdFlvUrl: "http://vodk32ywxdf.nosdn.127.net/nos/flv/2016/06/22/v32_sd.flv?NOSAccessKeyId=ab1856bb39044591939d7b94e1b8e5ee&Expires=1498558006&download=%E6%A0%87%E6%B8%85_watermark_test_1.flv&Signature=pGmKYIjWq/ZE9Gu8K1MZcuqQYG83cI2bnuiikLO8TCk=",
          vid: 32,
          shdMp4Size: 39874022,
          sdFlvUrl: "http://vodk32ywxdf.vod.126.net/vodk32ywxdf/nos/flv/2016/06/22/v32_sd.flv",
          sdFlvSize: 18013302,
          hdMp4Url: "http://vodk32ywxdf.vod.126.net/vodk32ywxdf/nos/mp4/2016/06/22/v32_hd.mp4",
          status: 40,
          updateTime: 1466663164342,
          sdMp4Url: "http://vodk32ywxdf.vod.126.net/vodk32ywxdf/nos/mp4/2016/06/22/v32_sd.mp4",
          downloadHdMp4Url: "http://vodk32ywxdf.nosdn.127.net/nos/mp4/2016/06/22/v32_hd.mp4?NOSAccessKeyId=ab1856bb39044591939d7b94e1b8e5ee&Expires=1498558006&download=%E9%AB%98%E6%B8%85_watermark_test_1.mp4&Signature=kMUKJGcW8aSFauL2836pXA5UrEeowq2hLdpgMpjmr44=",
          downloadShdMp4Url: "http://vodk32ywxdf.nosdn.127.net/nos/mp4/2016/06/22/v32_shd.mp4?NOSAccessKeyId=ab1856bb39044591939d7b94e1b8e5ee&Expires=1498558006&download=%E8%B6%85%E6%B8%85_watermark_test_1.mp4&Signature=ch30+tX20b54UeskhFZs37r55jkt2WIV87jlaZgKmPY=",
          typeName: "默认分类",
          duration: 195,
          snapshotUrl: "http://vodk32ywxdf.nosdn.127.net/6c4a9501-ee3c-4e00-9a5f-20f6616f0ad3.jpg",
          initialSize: 15601202,
          typeId: 38,
          completeTime: 1466663164342
        }
      }
    end

    test 'update_video_list' do
      course = live_studio_courses(:course_without_channel)
      response = Typhoeus::Response.new(code: 200, body: @create_response_body1)
      response_record = Typhoeus::Response.new(code: 200, body: @set_record_response_body)
      response_list = Typhoeus::Response.new(code: 200, body: @get_record_video_list_body)
      response_info = Typhoeus::Response.new(code: 200, body: @get_video_info_body)
      Typhoeus.stub('https://vcloud.163.com/app/channel/create').and_return(response)
      Typhoeus.stub('https://vcloud.163.com/app/channel/setAlwaysRecord').and_return(response_record)
      Typhoeus.stub('https://vcloud.163.com/app/videolist').and_return(response_list)
      Typhoeus.stub('https://vcloud.163.com/app/vod/video/get').and_return(response_info)

      channel = course.init_channel
      assert_difference 'channel.channel_videos.count', 2, '没有更新录播视频列表' do
        channel.set_always_recorded && channel.update_video_list
      end
      assert_equal ['test_course_1', 'test_course_2'], channel.channel_videos.map(&:name), '没有正确更新录播视频列表'
      assert_equal '15601202', channel.channel_videos.first.initial_size, '没有正确更新视频信息'
    end
  end
end
