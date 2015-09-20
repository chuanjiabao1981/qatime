require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  test "teacher login" do
    teacher1 =  Teacher.find(users(:teacher1).id)
    get signin_path
    assert_template 'sessions/new'
    post sessions_path,user: { email: teacher1.email, password: "password" }

    assert_redirected_to homeworks_teacher_path(teacher1)
    follow_redirect!
    assert_response :success

    #老师主页 是否正确包含信息编辑的连接
    #assert_select "a[href=?]", edit_teacher_path(teacher1), count: 1
  end
end
