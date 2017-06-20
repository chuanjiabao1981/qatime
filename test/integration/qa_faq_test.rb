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
    visit qa_faqs_path
    assert page.has_content?(QaFaq.last.title)
    assert page.has_link? '辅导流程'
    assert page.has_link? '老师如何开课'
    assert page.has_link? '学生如何学习'
    assert page.has_link? '常见问题'
    assert page.has_link? '增加常见问题'
    assert page.has_link? '用户协议'

    click_link '辅导流程'
    assert page.has_content?('观看直播')
    assert page.has_content?('进行直播')
    new_logout_as(@user)
  end

  test 'student cant find teacher_faq' do
    @user = users(:student1)
    new_log_in_as(@user)
    visit qa_faqs_path
    assert !page.has_content?('老师如何开课'), '学生不该找到 "老师如何开课"'
    visit teacher_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '学生不应该访问 "老师如何开课"'
    new_logout_as(@user)
  end

  test 'teacher cant find student_faq' do
    @user = users(:physics_teacher1)
    new_log_in_as(@user)
    visit qa_faqs_path
    assert !page.has_content?('学生如何学习'), '老师不该找到 "学生如何学习"'
    visit student_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '老师不该访问 "学生如何学习"'
    new_logout_as(@user)
  end

  test 'guest cant find teacher and student_faq' do
    visit qa_faqs_path
    assert !page.has_content?('学生如何学习'), '游客不该找到 "学生如何学习"'
    visit student_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '游客不该访问 "学生如何学习"'
    assert !page.has_content?('老师如何开课'), '游客不该找到 "老师如何开课"'
    visit teacher_qa_faqs_path
    assert page.has_content?('您没有权限进行这个操作!'), '游客不应该访问 "老师如何开课"'
  end

  test 'visit user_agreements page' do
    visit user_agreements_qa_faqs_path
    assert page.has_link? '学生版用户协议和隐私条款'
    assert page.has_link? '老师版用户协议和隐私条款'

    click_on '学生版用户协议和隐私条款'
    assert page.has_content? '《答疑时间》学习网学生使用协议和隐私条款'

    visit user_agreements_qa_faqs_path
    click_on '老师版用户协议和隐私条款'
    assert page.has_content? '《答疑时间》学习网答疑名师服务协议'
  end
end
