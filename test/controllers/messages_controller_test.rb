require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  setup do
    teacher1 = users(:teacher1)
    @cc = customized_courses(:customized_course1)
  end

  test 'should get customized course messages' do
    get :index, customized_course_id: @cc.id
    assert_response :ok
  end

  test 'should create text messages' do
    content = 'hello world'
    post :index, customized_course_id: @cc.id, 'text_message_content': content
    assert_response :ok
  end
end
