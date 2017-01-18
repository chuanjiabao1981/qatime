require 'test_helper'

module LiveStudio
  class LessonTest < ActiveSupport::TestCase
    # test "the truth" do
    #   assert true
    # end

    # 测试同步回放视频
    test "sync replays" do
      sync_replay_res = {
        code: 200,
        msg: '',
        ret: {
          videoList: [{vid: Time.now.to_i.to_s,
                       name: 'testssss',
                       url: 'http://baidu.com',
                       beginTime: 40.minutes.ago.to_i * 100,
                       endTime: 10.minutes.ago.to_i * 100
          }]
        }
      }.to_json
      video_res = {
        code: 200,
        msg: '',
        ret: {
          duration: 20,
          orig_url: 'http://baidu.com'
        }
      }.to_json
      Typhoeus.stub('https://vcloud.163.com/app/vodvideolist').and_return(Typhoeus::Response.new(code: 200, body: sync_replay_res))
      Typhoeus.stub('https://vcloud.163.com/app/vod/video/get').and_return(Typhoeus::Response.new(code: 200, body: video_res))

      lesson = live_studio_lessons(:replay_lessons_7)
      assert_difference "lesson.channel_videos.count", 1, "同步回放视频失败" do
        lesson.sync_replays
      end
      assert lesson.synced?, "没有改变视频同步状态"
    end

    # 测试回放次数
    test 'user left replay times' do
      lesson1 = live_studio_lessons(:replay_lessons_1)
      lesson2 = live_studio_lessons(:replay_lessons_2)
      lesson3 = live_studio_lessons(:replay_lessons_3)
      student = users(:student_with_order2)
      assert_equal 0, lesson1.user_left_times(student), '剩余回放次数错误'
      assert_equal 1, lesson2.user_left_times(student), '剩余回放次数错误'
      assert_equal 2, lesson3.user_left_times(student), '剩余回放次数错误'
    end

    # 测试回放权限
    test 'replay permission' do
      lesson = live_studio_lessons(:replay_lessons_1)
      lesson2 = live_studio_lessons(:replay_lessons_2)
      admin = users(:admin)
      assert lesson.replayable_for?(admin), "管理员观看回放失败" # 管理员可以观看回放
      
      student = users(:student_for_replays)
      assert lesson.replayable_for?(student), "学生观看回放失败" # 已经购买并且没有用完回放次数可以回放
      assert_not lesson2.replayable_for?(student), "回放权限控制失效" # 已经购买并且没有用完回放次数可以回放

      student2 = users(:student_can_no_replays)
      assert_not lesson.replayable_for?(student2), "回放权限控制失效"
    end

  end
end
