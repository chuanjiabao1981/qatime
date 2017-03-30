require 'test_helper'

class Qatime::TeacherInteractiveCoursesAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
  end

  # 我的一对一
  test 'teacher interactive courses list' do
    get "/api/v1/live_studio/teachers/#{@teacher.id}/interactive_courses", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_equal 3, @res['data'].count, '我的辅导数量不正确'
    get "/api/v1/live_studio/teachers/#{@teacher.id}/interactive_courses", { status: :published }, 'Remember-Token' => @remember_token
  end

  # 一对一详情
  test 'teacher interactive course detail' do
    course1 = live_studio_interactive_courses(:interactive_course_one_2)
    course2 = live_studio_interactive_courses(:interactive_course_two_1)
    course3 = live_studio_interactive_courses(:interactive_course_three_2)
    get "/api/v1/live_studio/interactive_courses/#{course1.id}", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_includes @res['data'], 'interactive_lessons'
    get "/api/v1/live_studio/interactive_courses/#{course2.id}", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_includes @res['data'], 'interactive_lessons'
    get "/api/v1/live_studio/interactive_courses/#{course3.id}", {}, 'Remember-Token' => @remember_token
    assert_request_success?
    assert_includes @res['data'], 'interactive_lessons'
  end
end
