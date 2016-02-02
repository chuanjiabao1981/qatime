require 'test_helper'

class SyllabusFlowsTest < LoginTestBase
  def setup
    super
    @syllabus = course_library_syllabuses(:syllabuses_one)
    @directory = course_library_directories(:directory_one)
  end

  test "syllabuses index" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.teacher_syllabuses_path(@teacher)
    @teacher_session.assert_response :success
    puts @syllabus.to_json
    puts @directory.to_json
    assert @syllabus.valid?
    assert @directory.valid?
    @teacher_session.assert_select 'a[href=?]', CourseLibrary::Engine.routes.url_helpers.syllabus_directory_path(@syllabus,@directory),1
  end

  test "syllabuses new and create" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_teacher_syllabus_path(@teacher)
    @teacher_session.assert_response :success

    c = @teacher.syllabuses.count
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.teacher_syllabuses_path(@teacher),
                          syllabus: {title:"new syllabus",description:"description for new syllabus"}
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal c+1,@teacher.syllabuses.count
  end

  test "syllabus edit and update" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.edit_teacher_syllabus_path(@teacher,@syllabus)
    @teacher_session.assert_response :success

    @teacher_session.patch CourseLibrary::Engine.routes.url_helpers.teacher_syllabus_path(@teacher,@syllabus),
                           syllabus: {title:"new syllabus title"}
    @teacher_session.assert_response :redirect
    @teacher_session.assert_equal 1,@teacher.syllabuses.where(title:"new syllabus title").count
  end

end


