require 'test_helper'

class QuestionCreateTest < ActionDispatch::IntegrationTest
  test "the truth" do
    get new_session_path
    assert_response :success
  end
end
