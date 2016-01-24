require 'test_helper'

module CourseLibrary
  class PublicationsFlowsTest < LoginTestBase
    def setup
      super
      @course = course_library_courses(:course_one)
    end
    test "customized_tutorials" do
      @teacher_session.get CourseLibrary::Engine.routes.url_helpers.customized_tutorials_course_path(@course)
      @teacher_session.assert_response :success
      @teacher_session.assert_select 'a[href=?]',
                                     CourseLibrary::Engine.routes.url_helpers.available_customized_courses_for_publish_course_path(@course)
    end
    test "available_customized_courses_for_publish_course" do
      @teacher_session.get CourseLibrary::Engine.routes.url_helpers.available_customized_courses_for_publish_course_path(@course)
      @teacher_session.assert_response :success
      @teacher_session.assert_select 'form[action=?]', CourseLibrary::Engine.routes.url_helpers.publish_course_path(@course)
      @course.available_customized_course_for_publish.each do |c|
        @teacher_session.assert_select "input[type=checkbox][value=\"#{c.id}\"][name=\"course[available_customized_course_ids][]\"]",1
      end
    end

    test "publish" do
      a = @course.available_customized_course_for_publish.first
      assert_difference 'CustomizedTutorial.count',1 do
        @teacher_session.post CourseLibrary::Engine.routes.url_helpers.publish_course_path(@course),
                              course: { available_customized_course_ids:[a.id]}
        @teacher_session.assert_redirected_to CourseLibrary::Engine.routes.url_helpers.customized_tutorials_course_path(@course)
      end
    end
  end
end