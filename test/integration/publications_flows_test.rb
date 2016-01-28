require 'test_helper'

class PublicationsFlowsTest < LoginTestBase

  def setup
    super
    @course = course_library_courses(:course_one)
  end
  test "index page" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.course_publications_path(@course,teacher_id: @teacher.id)
    @teacher_session.assert_response :success
    @teacher_session.assert_select  "a[href=?]", CourseLibrary::Engine.routes.url_helpers.new_course_publication_path(@course,teacher_id: @teacher.id),1
  end

  test "new page" do
    @teacher_session.get CourseLibrary::Engine.routes.url_helpers.new_course_publication_path(@course,teacher_id: @teacher.id)
    @teacher_session.assert_response :success
    @teacher_session.assert_select "form[action=?]", CourseLibrary::Engine.routes.url_helpers.course_publications_path(@course,teacher_id: @teacher.id)
    @teacher.customized_courses.each do |customized_course|
      @teacher_session.assert_select "input[type=checkbox][value=\"#{customized_course.id}\"][name=\"course[customized_course_ids][]\"]",1
    end
  end

  test "create page" do
    assert_difference "CourseLibrary::Publication.count",1 do
      @teacher_session.post CourseLibrary::Engine.routes.url_helpers.course_publications_path(@course,teacher_id: @teacher.id),
                          course: { customized_course_ids:[@teacher.customized_courses.first.id]}
    end
    @teacher_session.assert_redirected_to CourseLibrary::Engine.routes.url_helpers.course_publications_path(@course,teacher_id: @teacher.id)
  end
end
