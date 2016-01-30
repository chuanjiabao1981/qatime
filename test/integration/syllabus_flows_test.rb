require 'test_helper'

class SyllabusFlowsTest < LoginTestBase
  def setup
    super
  end

  test "syllabus index" do
    @teacher_session.get course_library.syllabuses_path
    @teacher_session.assert_response :success
  end

end


