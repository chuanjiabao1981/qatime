require 'test_helper'

require 'sidekiq/testing'

Sidekiq::Testing.inline!

class CustomizedCourseMessageIntegrateTest < LoginTestBase

  def setup
    @customized_course_message_board = customized_course_message_boards(:customized_course_message_board)
    @customized_course_message       = customized_course_messages(:customized_course_message1)
    super
  end

  test "index page" do
    index_page(@teacher,@teacher_session,@customized_course_message_board)
    index_page(@student,@student_session,@customized_course_message_board)
  end

  test "new page" do
    new_page(@teacher_session,@customized_course_message_board)
    new_page(@student_session,@customized_course_message_board)
  end

  test "create page" do
    create_page(@teacher_session,@customized_course_message_board)
    create_page(@student_session,@customized_course_message_board)
  end

  test "show page" do
    show_page(@teacher,@teacher_session,@customized_course_message)
    show_page(@student,@student_session,@customized_course_message)
  end

  test "edit page" do
    edit_page(@teacher,@teacher_session,@customized_course_message)
    edit_page(@student,@student_session,@customized_course_message)
  end

  test "update page" do
    update_page(@teacher,@teacher_session,@customized_course_message)
    update_page(@student,@student_session,@customized_course_message)
  end

  private

  def update_page(user,user_session,customized_course_message)
    update_path = customized_course_message_path(customized_course_message)
    title       = random_str
    content     = random_str
    user_session.put update_path, params: { customized_course_message: { title: title,content: content } }
    if user.id != customized_course_message.author.id
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_redirected_to customized_course_message_path(customized_course_message)
    user_session.follow_redirect!
    user_session.assert_select  'h4',title
    user_session.assert_select  'div',content
  end

  def edit_page(user,user_session,customized_course_message)
    edit_path   = edit_customized_course_message_path(customized_course_message)

    user_session.get edit_path
    if user.id != customized_course_message.author.id
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',customized_course_message_path(customized_course_message)
  end
  def show_page(user,user_session,customized_course_message)
    show_path   = customized_course_message_path(customized_course_message)
    user_session.get show_path
    user_session.assert_response :success
    user_session.assert_select 'div',customized_course_message.content
    user_session.assert_select 'h4',customized_course_message.title
    edit_link_num   = 0
    if user.id == customized_course_message.author.id
      edit_link_num = 1
    end
    user_session.assert_select 'a[href=?]',edit_customized_course_message_path(customized_course_message),edit_link_num
  end
  def create_page(user_session,customized_course_message_board)
    create_path  = customized_course_message_board_customized_course_messages_path(customized_course_message_board)
    title        = random_str
    content      = random_str
    user_session.post create_path, params: { customized_course_message: { title: title ,content: content } }
    new_customized_course_message = CustomizedCourseMessage.all.order(created_at: :desc).first
    user_session.assert_redirected_to customized_course_message_path(new_customized_course_message)
    user_session.follow_redirect!
    user_session.assert_select 'div',content

  end
  def new_page(user_session,customized_course_message_board)
    user_session.get new_customized_course_message_board_customized_course_message_path(customized_course_message_board)
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]',customized_course_message_board_path(customized_course_message_board),1
    user_session.assert_select 'a[href=?]',customized_course_path(customized_course_message_board.customized_course),1
    user_session.assert_select 'form[action=?]', customized_course_message_board_customized_course_messages_path(customized_course_message_board),1


  end
  def index_page(user,user_session,customized_course_message_board)
    user_session.get customized_course_message_board_path(customized_course_message_board)
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]',customized_course_message_path(@customized_course_message),1
    user_session.assert_select 'a[href=?]',new_customized_course_message_board_customized_course_message_path(customized_course_message_board),1
  end
end
