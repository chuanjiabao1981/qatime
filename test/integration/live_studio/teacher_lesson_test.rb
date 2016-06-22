require 'test_helper'

class LiveStudio::TeacherLessonTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @routes = LiveStudio::Engine.routes.url_helpers
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @manager = ::Manager.find(users(:manager).id)
    @workstation = @manager.workstations.sample

    @teacher = ::Teacher.find(users(:teacher_one).id)

    @teacher_session = log_in2_as(@teacher)
    @course = live_studio_courses(:course_one)
    @lesson = live_studio_lessons(:lesson_one)
    @course.lessons << @lesson
    @course.teacher = @teacher
    @course.save
  end

  def teardown
    log_out2(@teacher_session)
    Capybara.use_default_driver
  end

  test "teacher lesson index view " do
    @teacher_session.get @routes.teacher_courses_path(@course)
    @teacher_session.assert_response :success
  end

  test 'teacher lesson new and create' do
    @teacher_session.get @routes.new_teacher_course_lesson_path(@course)
    @teacher_session.assert_response :success

    c = @course.lessons.count
    @teacher_session.post @routes.teacher_course_lessons_path(@course),
                          lesson: {
                              name:"new lesson",
                              description:"lesson description ",
                              course_id: @course.id,
                              start_time: '10:10',
                              end_time: '17:10',
                              class_date: '2016-10-1'
                          }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c+1,@course.lessons.count
  end

  test 'teacher lesson edit and update' do
    @teacher_session.get @routes.edit_teacher_course_lesson_path(@course,@lesson)
    @teacher_session.assert_response :success

    @teacher_session.patch @routes.teacher_course_lesson_path(@course,@lesson),
                           lesson: {name:"new lesson x1"}
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal 1,@course.lessons.where(name:"new lesson x1").count
  end
end
