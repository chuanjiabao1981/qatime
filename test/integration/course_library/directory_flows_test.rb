require 'test_helper'

class DirectoryFlowsTest < LoginTestBase
  def setup
    super
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
    @chapter1 = course_library_directories(:chapter1)
    @course = course_library_courses(:course_one)
  end

  test "directory show" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.syllabus_directory_path(@syllabus,@directory)
    @teacher_session.assert_response :success
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.syllabus_directory_path(@syllabus,@chapter1),1
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.course_path(@course),1
  end

  test "directories new and create" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_syllabus_directory_path(@syllabus,:p => @directory)
    @teacher_session.assert_response :success

    c = @syllabus.directories.count
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.syllabus_directories_path(@syllabus),
                          params: { directory: { parent_id: @directory.id, title: "new directory" } }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c+1,@syllabus.directories.count
  end

  test "directories edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_syllabus_directory_path(@syllabus,@chapter1)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.syllabus_directory_path(@syllabus,@chapter1),
                           params: { directory: { title: "chapter1 new" } }
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal 1, @syllabus.directories.where(title: "chapter1 new").count
  end

  test "directories move children" do
    first = @directory.children.first
    second = @directory.children.second
    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.move_higher_directory_path(second)
    @directory.reload
    @teacher_session.assert_equal second.id, @directory.children.first.id
    @teacher_session.assert_equal first.id, @directory.children.second.id
    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.move_lower_directory_path(second)
    @directory.reload
    @teacher_session.assert_equal first.id, @directory.children.first.id
    @teacher_session.assert_equal second.id, @directory.children.second.id
  end

  test "directories move courses" do
    first = @directory.courses.first
    second = @directory.courses.second
    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.move_higher_course_path(second)
    @directory.reload
    @teacher_session.assert_equal second.id, @directory.courses.first.id
    @teacher_session.assert_equal first.id, @directory.courses.second.id
    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.move_lower_course_path(second)
    @directory.reload
    @teacher_session.assert_equal first.id, @directory.courses.first.id
    @teacher_session.assert_equal second.id, @directory.courses.second.id
  end
end

