require 'test_helper'

class Qatime::StudentInteractiveCoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  # 我的一对一
  test 'student interactive student courses list' do
    get "/api/v1/live_studio/students/#{@student.id}/interactive_courses", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal 2, @res['data'].count, '我的辅导数量不正确'
    get "/api/v1/live_studio/students/#{@student.id}/interactive_courses", { status: :published }, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal 1, @res['data'].count, '待开课数量不正确'
    get "/api/v1/live_studio/students/#{@student.id}/interactive_courses", { status: :teaching }, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_equal 1, @res['data'].count, '已开课数量不正确'
  end

  # 一对一详情
  test 'student interactive course deatil' do
    course1 = live_studio_interactive_courses(:interactive_course_three_1)
    course2 = live_studio_interactive_courses(:interactive_course_three_2)
    course3 = live_studio_interactive_courses(:interactive_course_two_3)
    get "/api/v1/live_studio/interactive_courses/#{course1.id}", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert @res['data']['is_bought']
    get "/api/v1/live_studio/interactive_courses/#{course2.id}", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert @res['data']['is_bought']
    get "/api/v1/live_studio/interactive_courses/#{course3.id}", {}, 'Remember-Token' => @student_remember_token
    assert_request_success?
    assert_not @res['data']['is_bought']
  end
end
