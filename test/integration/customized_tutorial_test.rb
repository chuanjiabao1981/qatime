class CustomizedTutorialIntegrateTest < LoginTestBase
  set_fixture_class :homeworks => Exercise
  fixtures :homeworks


  def setup
    super
    @customized_tutorial = customized_tutorials(:customized_tutorial1)
  end

  def index_page
    ##在customized_course中已经测试过了
  end

  test 'show page' do
    show_page(@student_session,@student)
    show_page(@teacher_session,@teacher)
  end

  test "not show page " do
    not_show_page(@student_session,@student)
    not_show_page(@teacher_session,@teacher)
  end


  private
  def show_page(user_session,user)
    topic = topics(:customized_tutorial_topic1)
    user_session.get customized_tutorial_path(@customized_tutorial)
    user_session.assert_response :success
    user_session.assert_select 'source[src=?]', @customized_tutorial.video.name.url , 1
    user_session.assert_select 'a[href=?]',     customized_course_path(@customized_tutorial.customized_course),1
    user_session.assert_select 'a[href=?]',    tutorial_issue_path(topic),1

    exercise = homeworks(:exercise_one)
    assert exercise.valid?


    if user.teacher?
      user_session.assert_select 'a[href=?]',    new_customized_tutorial_tutorial_issue_path(@customized_tutorial),0
    elsif user.student?
      user_session.assert_select 'a[href=?]',    new_customized_tutorial_tutorial_issue_path(@customized_tutorial),1
    end
    if user.teacher?
      user_session.assert_select 'a[href=?]',edit_customized_tutorial_path(@customized_tutorial),1
    else
      user_session.assert_select 'a[href=?]',edit_customized_tutorial_path(@customized_tutorial),0
    end
    user_session.assert_select 'a[href=?]', exercise_path(exercise),1
    if user.teacher?
      user_session.assert_select 'a[href=?]', new_customized_tutorial_exercise_path(@customized_tutorial),1
    elsif user.student?
      user_session.assert_select 'a[href=?]', new_customized_tutorial_exercise_path(@customized_tutorial),0

    end
  end

  def not_show_page(user_session,user)
    customized_tutorial2 = customized_tutorials(:customized_tutorial2)
    user_session.get customized_tutorial_path(customized_tutorial2)
    user_session.assert_redirected_to get_home_url(user)
  end

end