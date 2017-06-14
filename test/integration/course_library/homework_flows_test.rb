require 'test_helper'

class CourseFlowsTest < LoginTestBase
  def setup
    super
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @course = course_library_courses(:course_one)
    @homework = course_library_homeworks(:homework_one)
  end
  test "homework show" do
    @homework.qa_files << qa_files(:one)
    @homework.qa_files << qa_files(:two)
    @homework.solutions << course_library_solutions(:solution_one_for_homework_one)
    @homework.solutions << course_library_solutions(:solution_two_for_homework_one)
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.homework_path(@homework)
    @teacher_session.assert_response :success
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_homework_path(@homework),1
    @teacher_session.assert_select 'a[href=?]', qa_files(:one).name.url,1
    @teacher_session.assert_select 'a[href=?]', qa_files(:two).name.url,1

    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.new_homework_solution_path(@homework),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.solution_path(course_library_solutions(:solution_one_for_homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.solution_path(course_library_solutions(:solution_two_for_homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.mark_delete_solution_path(course_library_solutions(:solution_one_for_homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.mark_delete_solution_path(course_library_solutions(:solution_two_for_homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_solution_path(course_library_solutions(:solution_one_for_homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_solution_path(course_library_solutions(:solution_two_for_homework_one)),1
  end

  test "homework mark delete" do
    assert_difference '@course.homeworks.count', -1 do
      @teacher_session.delete CourseLibrary::Engine.routes.url_helpers.mark_delete_homework_path(@homework)
    end
  end

  test "homework new and create" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_course_homework_path(@course)
    @teacher_session.assert_response :success

    c = @course.homeworks.count
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.course_homeworks_path(@course),
                          params: { homework: { title: "new homework", description: "new description" } }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c + 1, @course.homeworks.count
  end

  test "homework edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_homework_path(@homework)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.homework_path(@homework),
                           params: { homework: { title: "homework title", description: "new description" } }
    @teacher_session.assert_response :redirect
    @homework.reload
    @teacher_session.assert_equal "homework title", @homework.title
    @teacher_session.assert_equal "new description", @homework.description
  end
end
