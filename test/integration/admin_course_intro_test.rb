require 'test_helper'

class AdminCourseIntroTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
    @admin = users(:admin)
    new_log_in_as(@admin)
    visit get_home_url(@admin)
  end

  def teardown
    new_logout_as(@admin)
    Capybara.use_default_driver
  end

  test "visit course intro" do
    click_on '视频介绍'
    assert page.has_content? '视频信息'
    assert page.has_content? '视频启用'
    click_on '新增视频'
    fill_in :course_intro_title, with: '测试视屏1'
    id = find('.video_file', visible: false)['token']
    attach_file("video_file_#{id}", "#{Rails.root}/test/integration/test.mp4", visible: false)
    sleep(3)
    click_on '保存'

    assert page.has_content? '测试视屏1'

    click_on '编辑', match: :first
    fill_in :course_intro_title, with: '测试视屏2'
    click_on '保存'
    assert page.has_content? '测试视屏2'

    click_on '使用', match: :first
    assert page.has_link? '停止使用'
    course_intro = CourseIntro.order(created_at: :desc).first
    assert page.has_link?('播放', href: play_course_intro_path(course_intro))
  end
end
