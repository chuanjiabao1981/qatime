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

  test "solution mark delete" do
    assert_difference '@homework.solutions.count' ,-1 do
      @teacher_session.delete CourseLibrary::Engine.routes.url_helpers.mark_delete_solution_path(@solution)
    end
  end

  test "solution new and create" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_homework_solution_path(@homework)
    @teacher_session.assert_response :success

    c = @homework.solutions.count
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.homework_solutions_path(@homework),
                          params: { solution: { title: "new solution", description: "new description" } }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c + 1, @homework.solutions.count
  end

  test "solution edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_solution_path(@solution)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.solution_path(@solution),
                           params: { solution: { title: "solution title", description: "new description" } }
    @teacher_session.assert_response :redirect
    @solution.reload
    @teacher_session.assert_equal "solution title", @solution.title
    @teacher_session.assert_equal "new description", @solution.description
  end
end
