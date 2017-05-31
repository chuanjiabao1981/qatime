require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class CustomizedCourseMessageReplyIntegrateTest < LoginTestBase

  def setup
    @customized_course_message        = customized_course_messages(:customized_course_message1)
    @customized_course_message_reply  = customized_course_message_replies(:customized_course_message_reply1)
    assert @customized_course_message_reply.valid?
    super
  end

  test "index page" do
    index_page(@teacher,@teacher_session,@customized_course_message_reply)
    index_page(@student,@student_session,@customized_course_message_reply)
  end

  test "show page" do
    show_page(@teacher_session,@customized_course_message_reply)
    show_page(@student_session,@customized_course_message_reply)
  end


  test "create_page" do
    create_page(@teacher,@teacher_session,@customized_course_message)
    create_page(@student,@student_session,@customized_course_message)
  end

  private
  def show_page(user_session,customized_course_message_reply)
    user_session.get customized_course_message_reply_path(customized_course_message_reply)
    user_session.assert_redirected_to customized_course_message_path(customized_course_message_reply.customized_course_message,
                                          page: 1,
                                          customized_course_message_reply_animate: customized_course_message_reply.id,
                                          anchor: "customized_course_message_reply_#{customized_course_message_reply.id}"
                                      )
  end
  def create_page(user, user_session, customized_course_message)
    create_path = customized_course_message_customized_course_message_replies_path(customized_course_message)
    content     = random_str
    assert_difference 'CustomizedCourseMessageReply.count', 1 do
      user_session.post create_path, params: { customized_course_message_reply: { content: content } }
    end
    user_session.assert_redirected_to customized_course_message_path(customized_course_message)
    user_session.follow_redirect!
    user_session.assert_select 'div',content
  end
  def index_page(user,user_session,customized_course_message_reply)
    user_session.get customized_course_message_path(customized_course_message_reply.customized_course_message)
    user_session.assert_response :success
    user_session.assert_select 'div',customized_course_message_reply.content
    edit_link_num   =   0
    if user.id == customized_course_message_reply.author.id
      edit_link_num = 1
    end
    user_session.assert_select 'a[href=?]',edit_customized_course_message_reply_path(customized_course_message_reply), edit_link_num
    user_session.assert_select 'form[action=?]',
                               customized_course_message_customized_course_message_replies_path(
                                   customized_course_message_reply.customized_course_message,
                                   anchor: :new_customized_course_message_reply
                               )
  end

end
