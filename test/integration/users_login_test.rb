require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @headless = Headless.new
    @headless.start
    Capybara.current_driver = :selenium_chrome

    @teacher = users(:physics_teacher1)
  end

  def teardown
    Capybara.use_default_driver
  end

  # test "teacher login" do
  #   teacher1 =  Teacher.find(users(:teacher1).id)
  #   get signin_path
  #   assert_template 'sessions/new'
  #   post sessions_path,user: { email: teacher1.email, password: "password" }

  #   assert_redirected_to solutions_teacher_path(teacher1)
  #   follow_redirect!
  #   assert_response :success

  #   #老师主页 是否正确包含信息编辑的连接
  #   #assert_select "a[href=?]", edit_teacher_path(teacher1), count: 1
  # end

  test 'user login' do
    user = users(:teacher1)
    visit root_path
    click_on "登录", match: :first

    fill_in :user_login_account, with: user.email
    fill_in :user_password, with: 'password'
    check :remember_account
    click_button "登录", match: :first

    assert page.has_content?('欢迎登录!'), "登录不成功"
    new_logout_as(user)
    visit root_path
    click_on "登录", match: :first
    assert_equal user.email, find(:css, '#user_login_account').value, "没有记住帐号"
  end
end
