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
                          directory: {parent_id:@directory.id,title:"new directory"}
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c+1,@syllabus.directories.count
  end

  test "directories edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_syllabus_directory_path(@syllabus,@chapter1)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.syllabus_directory_path(@syllabus,@chapter1),
                           directory: {title:"chapter1 new"}
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal 1,@syllabus.directories.where(title:"chapter1 new").count
  end

end


