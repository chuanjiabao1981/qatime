require 'test_helper'

class Qatime::GroupAPITest < ActionDispatch::IntegrationTest
  def setup
    @teacher = users(:teacher1)
    @remember_token = api_login_by_pc(@teacher, :teacher_live)
    @student = users(:student_one_with_course)
    @student_remember_token = api_login(@student, :app)
  end

  test "customized group search" do
  end
end
