require 'test_helper'

class QaFaqTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome
  end

  def teardown
    Capybara.use_default_driver
  end

  test 'test link' do
    @user = users(:admin)
    new_log_in_as(@user)
    click_link '帮助',match: :first
    assert page.has_content?(QaFaq.last.title)
    click_link '辅导班流程'
    assert find(:xpath, "//img[@alt='Course help' and @src='/imgs/course_help.jpg']"), '没找到图片'
    click_link '老师使用说明'
    assert page.has_content?('第一步：设置辅导班')
    click_link '学生使用说明'
    assert page.has_content?('第一/二步：搜索和购买辅导班')
    new_logout_as(@user)
  end

  test 'student cant find teacher_faq' do
    @user = users(:student1)
    new_log_in_as(@user)
    click_link '帮助',match: :first
    assert !page.has_content?('老师使用说明'), '学生不该找到 "老师使用说明"'
    visit teacher_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '学生不应该访问 "老师使用说明"'
    new_logout_as(@user)
  end

  test 'teacher cant find student_faq' do
    @user = users(:physics_teacher1)
    new_log_in_as(@user)
    click_link '帮助',match: :first
    assert !page.has_content?('学生使用说明'), '老师不该找到 "学生使用说明"'
    visit student_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '老师不该访问 "学生使用说明"'
    new_logout_as(@user)
  end

  test 'guest cant find teacher and student_faq' do
    visit root_path
    click_link '帮助',match: :first
    assert !page.has_content?('学生使用说明'), '游客不该找到 "学生使用说明"'
    visit student_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '游客不该访问 "学生使用说明"'
    assert !page.has_content?('老师使用说明'), '游客不该找到 "老师使用说明"'
    visit teacher_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '游客不应该访问 "老师使用说明"'
  end
end
