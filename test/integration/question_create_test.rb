require 'test_helper'

class QuestionCreateTest < ActionDispatch::IntegrationTest
  test "the truth" do
    teacher1 = users(:teacher1)
    visit new_session_path
    fill_in :user_email,with: teacher1.email
    fill_in :user_password,with: 'password'
    click_button '登录'
    visit questions_path
    print page.html
  end
end
