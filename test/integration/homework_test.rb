class HomeworkIntegrateTest < LoginTestBase
  def setup
    super
    @customized_course = customized_courses(:customized_course1)
    @homework1         = homeworks(:homework1)
    @homework2         = homeworks(:homework2)
  end

  test 'show page' do

    #puts user_session.response.body
    show_page(@teacher,@teacher_session,homeworks_customized_course_path(@customized_course))
    show_page(@student,@student_session,homeworks_customized_course_path(@customized_course))
  end

  test 'new page' do
    new_page(@teacher,@teacher_session,new_customized_course_homework_path(@customized_course))
    new_page(@student,@student_session,new_customized_course_homework_path(@customized_course))
  end

  test 'create page' do
    create_path  = customized_course_homeworks_path(@customized_course)
    create_page(@teacher,@teacher_session,create_path)
    create_page(@student,@student_session,create_path)
  end

  test 'edit page' do
    edit_path    = edit_homework_path(@homework2)

    edit_page(@teacher,@teacher_session,edit_path)
    edit_page(@student,@student_session,edit_path)
  end
  test 'update page' do
    update_path = customized_course_homework_path(@customized_course,@homework1)

    update_page(@teacher,@teacher_session,update_path)
    update_page(@student,@student_session,update_path)
  end

  private

  def edit_page(user,user_session,edit_path)
    user_session.get edit_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',customized_course_homework_path(@customized_course,@homework2)
    user_session.assert_template 'homeworks/edit','homeworks/_form'
    user_session.assert_select '#homework_title' do
      user_session.assert_select '[value=?]',@homework2.title,1
    end
  end
  def create_page(user,user_session,create_path)
    title        = "cccxxxedddwwwssssxxxxxxxxxxxx"
    content      = "oo00344ddcdagpi2er1inv"
    if user.student?
      assert_difference 'Homework.count',0 do
        user_session.post create_path, homework:{title: title, content: content}
        user_session.assert_redirected_to get_home_url(user)
      end
      return
    end

    assert_difference 'Homework.count',1 do
      assert_difference '@customized_course.reload.homeworks_count',1 do
        assert_difference '@customized_course.reload.exercises_count',0 do
          user_session.post create_path, homework:{title: title, content: content}
          new_homework =  Homework.where(title: title).order(:created_at).last

          user_session.assert_redirected_to customized_course_homework_path(@customized_course,new_homework)
          user_session.follow_redirect!
          user_session.assert_select 'h4',title
        end
      end
    end
  end

  def update_page(user,user_session,update_path)
    if user.teacher?
      title = "xdfstitleeeeeee update title update"
      user_session.put update_path,homework:{title: title,content: "xxxxxxxxxxxxxx"}
      user_session.assert_redirected_to homework_path(@homework1)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    else
      user_session.assert_redirected_to get_home_url(user)

    end
  end
  def new_page(user,user_session,new_path)
    if user.teacher?
      user_session.get new_path
      user_session.assert_response :success
      user_session.assert_select 'form[action=?]',customized_course_homeworks_path(@customized_course),1
      user_session.assert_template 'homeworks/new','homeworks/_form'
    else
      user_session.assert_redirected_to get_home_url(user)

    end
  end
  def show_page(user,user_session,show_path)
    user_session.get show_path
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]',homework_path(@homework1),1
    user_session.assert_select 'a[href=?]',homework_path(@homework2),1
    if user.teacher?
      user_session.assert_select 'a[href=?]', new_customized_course_homework_path(@customized_course),1
      user_session.assert_select 'a[href=?]', edit_homework_path(@homework1),1
      user_session.assert_select 'a[href=?]', edit_homework_path(@homework2),1
    else
      user_session.assert_select 'a[href=?]', new_customized_course_homework_path(@customized_course),0
      user_session.assert_select 'a[href=?]', edit_homework_path(@homework1),0
      user_session.assert_select 'a[href=?]', edit_homework_path(@homework2),0
    end
  end
end