class HomeworkIntegrateTest < LoginTestBase
  def setup
    super
    @customized_course = customized_courses(:customized_course1)
    @homework1         = homeworks(:homework1)
    @homework2         = homeworks(:homework2)
  end

  test 'show page' do
    #user_session = @teacher_session
    #show_path    =
    #user_session.get show_path
    #user_session.assert_response :success
    #user_session.assert_select 'a[href=?]',homework_path(@homework1),1
    #user_session.assert_select 'a[href=?]',homework_path(@homework2),1
    #puts user_session.response.body
    show_page(@teacher_session,homeworks_customized_course_path(@customized_course))

  end


  private
  def show_page(user_session,show_path)
    user_session.get show_path
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]',homework_path(@homework1),1
    user_session.assert_select 'a[href=?]',homework_path(@homework2),1
  end
end