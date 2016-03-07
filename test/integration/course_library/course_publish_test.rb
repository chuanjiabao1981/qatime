require 'test_helper'

module CourseLibrary
  class PublicationsFlowsTest < LoginTestBase
    def setup
      super
      @course = course_library_courses(:course_one)
      @customized_course = customized_courses(:customized_course1)
    end
    test "course publication new" do

      @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_course_course_publication_path(@course)
      @teacher_session.assert_response :success

    end

    test "course publication create" do
      assert "CustomizedTutorial.count",1 do
        @teacher_session.post CourseLibrary::Engine.routes.url_helpers.course_course_publications_path(@course),
                            "course_publication_form"=>
                                {"customized_course_ids"=> [@customized_course.id],
                                 "publish_lecture_switch"=>"true",
                                 "homework_ids"=> @course.homework_ids
                                }
        @teacher_session.assert_redirected_to CourseLibrary::Engine.routes.url_helpers.course_course_publications_path(@course)
      end
    end
  end
end