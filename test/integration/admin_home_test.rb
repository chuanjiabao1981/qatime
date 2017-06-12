require 'test_helper'

class AdminHomePageTest < ActionDispatch::IntegrationTest
  def setup
    @admin            = Admin.find(users(:admin).id)
    @admin_session    = log_in2_as(@admin)
    @student1         = Student.find(users(:student1).id)
  end

  def teardown
    @admin              = nil
    log_out2(@admin_session)
    @admin_session      = nil
  end

  test "student customized courses" do
    @admin_session.get customized_courses_student_path(@student1)
    @admin_session.assert_select "a[href=?]", new_student_customized_course_path(@student1),count:1
  end
end
