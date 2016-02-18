require 'test_helper'

class CourseFlowsTest < LoginTestBase
  def setup
    super
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @course = course_library_courses(:course_one)
    @homework = course_library_homeworks(:homework_one)
    @solution = course_library_solutions(:solution_one_for_homework_one)
  end
  test "solution show" do
    @solution.videos << videos(:video_template_1)
    @solution.videos << videos(:video_template)
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.solution_path(@solution)
    @teacher_session.assert_response :success
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_solution_path(@solution),1
    @teacher_session.assert_select 'source[src=?]', videos(:video_template).name.url, 1
  end

end