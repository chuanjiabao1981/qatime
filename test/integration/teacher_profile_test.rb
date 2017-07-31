require 'test_helper'

class TeacherProfileTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'teacher profile page' do
    teacher = users(:teacher1)
    visit profile_teacher_path(teacher)

    assert page.has_content? teacher.name
    assert page.has_content? '课程可退'
    assert page.has_content? '资料完整'
    assert page.has_content? '在线授课'
    assert page.has_content? teacher.school.name
    assert page.has_content? '直播课'
    assert page.has_content? '一对一'
    assert page.has_content? '视频课'
    assert page.has_content? '专属课'

    teacher_data = DataService::TeacherData.new(teacher)
    assert page.all('ul#courses li').size, 6
    assert page.has_link? '更多'
    click_on '更多', match: :first
    assert page.all('ul#courses li').size, teacher_data.profile_courses.count
    assert page.all('ul#interactive_courses li').size, teacher_data.profile_interactive_courses.count
    assert page.all('ul#video_courses li').size, teacher_data.profile_video_courses.count
    assert page.all('ul#customized_groups li').size, teacher_data.profile_customized_groups.limit(6).count
  end
end
