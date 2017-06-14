require 'test_helper'

class CourseFlowsTest < LoginTestBase
  def setup
    super
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @course = course_library_courses(:course_one)
  end
  test "course show" do
    @course.videos << videos(:video_template_1)
    @course.videos << videos(:video_template)
    @course.qa_files << qa_files(:one)
    @course.qa_files << qa_files(:two)
    @course.homeworks << course_library_homeworks(:homework_one)
    @course.homeworks << course_library_homeworks(:homework_two)
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.course_path(@course)
    @teacher_session.assert_response :success
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_course_path(@course),1
    #@teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.customized_tutorials_course_path(@course),1
    @teacher_session.assert_select 'source[src=?]', videos(:video_template).name.url, 1
    @teacher_session.assert_select 'a[href=?]', qa_files(:one).name.url,1
    @teacher_session.assert_select 'a[href=?]', qa_files(:two).name.url,1

    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.new_course_homework_path(@course),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.homework_path(course_library_homeworks(:homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.homework_path(course_library_homeworks(:homework_two)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.mark_delete_homework_path(course_library_homeworks(:homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.mark_delete_homework_path(course_library_homeworks(:homework_two)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_homework_path(course_library_homeworks(:homework_one)),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.edit_homework_path(course_library_homeworks(:homework_two)),1
  end

  test "course mark delete" do
    assert_difference '@directory.courses.count' ,-1 do
      @teacher_session.delete CourseLibrary::Engine.routes.url_helpers.mark_delete_course_path(@course)
    end
  end

  test "course new and create" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_directory_course_path(@directory)
    @teacher_session.assert_response :success

    c = @directory.courses.count
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.directory_courses_path(@directory),
                          params: { course: { title:"new course", description: "new description" } }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c+1,@directory.courses.count
  end

  test "course edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_course_path(@course)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.course_path(@course),
                           params: { course: { title: "course title", description: "new description" } }
    @teacher_session.assert_response :redirect
    @course.reload
    @teacher_session.assert_equal "course title",@course.title
    @teacher_session.assert_equal "new description",@course.description
  end

  test "course delete and create new" do
    @teacher_session.delete CourseLibrary::Engine.routes.url_helpers.mark_delete_course_path(@course)
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_directory_course_path(@directory)
    @teacher_session.assert_response :success
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.directory_courses_path(@directory),
                          params: { course: { title: "new course", description: "new description" } }
    @directory.reload;

    @directory.courses.each_with_index do |c, index|
      @teacher_session.assert_equal index+1, c.position
    end
  end
end
