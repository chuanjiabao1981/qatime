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

  test "syllabuses new" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_teacher_syllabus_path(@teacher)
    @teacher_session.assert_response :success
  end

  test "syllabuses create" do
    @teacher_session.post CourseLibrary::Engine.routes.url_helpers.teacher_syllabuses_path(@teacher),
                          syllabus: {title:"new syllabus",description:"description for new syllabus"}
    @teacher_session.assert_response :redirect
    assert_equal 2,@teacher.syllabuses.count
  end

end


