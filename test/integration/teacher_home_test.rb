require 'test_helper'

class TeacherHomeTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @teacher = users(:teacher1)
    log_in_as(@teacher)
  end

  def teardown
    new_logout_as(@teacher)
    Capybara.use_default_driver
  end

  test "teacher lessons state page" do
    visit lessons_state_teacher_path(@teacher)
    assert page.has_content? '课程状态'
    assert page.has_link? '未提审'
    assert page.has_link? '审核中'
    assert page.has_link? '已发布'
    assert page.has_link? '被驳回'

    lessons = Lesson.by_state('editing').by_teacher(@teacher.id)
    assert_equal page.all('ul.manage-list li').size, lessons.count, "状态查询不正确"
  end

  test "teacher curriculums page" do
    visit curriculums_teacher_path(@teacher)
    assert page.has_content? '我的公共课'

    datas = @teacher.find_or_create_curriculums
    assert page.has_content? datas.first.teaching_program.subject
    assert_equal page.all('.common .row a').size, datas.count, "数量不正确"
  end

end
