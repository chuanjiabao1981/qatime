require 'test_helper'

class LiveStudio::TeacherLessonTest < ActionDispatch::IntegrationTest
  def setup
    @routes = LiveStudio::Engine.routes.url_helpers
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @manager = users(:manager)
    @workstation = @manager.workstations.sample

    @teacher = users(:teacher_one)

    @teacher_session = log_in2_as(@teacher)
    @course = live_studio_courses(:course_for_init)
    @lesson = live_studio_lessons(:ready_lesson_for_init_course)
    @course.lessons << @lesson
    @course.teacher = @teacher
    @course.save
  end

  def teardown
    log_out2(@teacher_session)
    Capybara.use_default_driver
  end

  test "teacher lesson index view " do
    @teacher_session.get @routes.teacher_courses_path(@teacher)
    @teacher_session.assert_response :success
  end

  # test 'teacher lesson new and create' do
  #   @teacher_session.get @routes.new_teacher_lesson_path(@teacher,course_id: @course)
  #   @teacher_session.assert_response :success
  #
  #   c = @course.lessons.count
  #   @teacher_session.post @routes.teacher_lessons_path(@teacher,course_id: @course),
  #                          {
  #                             new_name_1:"new lesson",
  #                             course_id: @course.id,
  #                             new_start_time_1: '10:10',
  #                             new_end_time_1: '17:10',
  #                             new_class_date_1: '2016-10-1',
  #                             delete_lesson_list: '',
  #                             insert_lesson_list: '1'
  #                         }
  #   @teacher_session.assert_response :redirect
  #   @teacher_session.assert_equal c+1,@course.lessons.count
  # end

  # test 'teacher lesson edit and update' do
  #   @teacher_session.get @routes.edit_teacher_lesson_path(@teacher,@lesson,course_id: @course)
  #   @teacher_session.assert_response :success
  #   lesson = @course.lessons.last
  #
  #   @teacher_session.post @routes.teacher_lessons_path(@teacher,course_id: @course),
  #                         {
  #                           "name_#{lesson.id}":"new lesson x1",
  #                           "course_id": @course.id,
  #                           "start_time_#{lesson.id}": '10:10',
  #                           "end_time_#{lesson.id}": '17:10',
  #                           "class_date_#{lesson.id}": '2016-10-1',
  #                           delete_lesson_list: '',
  #                           insert_lesson_list: ''
  #                         }
  #   @teacher_session.assert_equal 1,@course.lessons.where(name:"new lesson x1").count
  # end
end
