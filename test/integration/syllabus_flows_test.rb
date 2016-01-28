require 'test_helper'

module CourseLibrary
  class SyllabusFlowsTest < LoginTestBase
    def setup
      super
    end

    test "syllabus index" do
      @teacher_session.get CourseLibrary::Engine.routes.url_helpers.syllabuses_path
      @teacher_session.assert_response :success
    end

  end
end

