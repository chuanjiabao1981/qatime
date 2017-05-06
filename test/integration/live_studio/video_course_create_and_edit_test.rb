require 'test_helper'
require "database_cleaner"

module LiveStudio
  class VideoCourseCreateAndEditTest < ActionDispatch::IntegrationTest
    def setup
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @teacher = users(:teacher_one)
      log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
      DatabaseCleaner.clean
    end

    test "teacher create and edit a video course" do
      click_on '我的视频课'
      click_on '创建视频课'
      select '高三', from: 'video_course_grade'
      fill_in 'video_course_name', with: '创建一个视频课'
      find('div[contenteditable]').set('测试一下创建视频课')
      find('i.note-icon-picture').click
      attach_file('files', "#{Rails.root}/test/integration/test.jpg")
      click_on '下一步'
      assert_difference "@teacher.live_studio_video_courses.count", 1, "视频课创建失败" do
        5.times do |i|
          click_on '添加新课程'
          id = find('.edit-modal')['id'].split('_').last
          fill_in "video_course_video_lessons_attributes_new_video_lessons_#{id}_name", with: "第#{i}节课"
          find('.upload-video').click
          page.execute_script("$('#video_file_#{id}').show()")
          attach_file("video_file_#{id}", "#{Rails.root}/test/integration/test.mp4")
          sleep(3)
          click_on "保存"
        end
        click_on '提交审核'
        sleep(1)
      end
      sleep(2)
      assert_equal 5, @teacher.live_studio_video_courses.last.video_lessons_count
    end
  end
end
