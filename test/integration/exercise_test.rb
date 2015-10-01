require 'sidekiq/testing'

Sidekiq::Testing.inline!


class ExerciseIntegrateTest < LoginTestBase


  def setup
    super
    @customized_tutorial = customized_tutorials(:customized_tutorial1)
    @exercise = exercises(:exercise_one)

  end


  test "exercise new" do
    new_page(@student,@student_session)
    new_page(@teacher,@teacher_session)
  end

  test "exercise create" do
    create_page(@teacher,@teacher_session)
    create_page(@student,@student_session)
  end

  test "exercise edit" do
    edit_page(@teacher,@teacher_session)
    edit_page(@student,@student_session)
  end

  test "exercise update" do
    update_page(@teacher,@teacher_session)
    update_page(@student,@student_session)
  end

  test "exercise show" do
    show_page(@teacher,@teacher_session)
    show_page(@student,@student_session)
  end
private

  def show_page(user,user_session)
    user_session.get exercise_path(@exercise)
    user_session.assert_select 'h4',@exercise.title
    user_session.assert_select 'div',@exercise.content
    if user.student?
      user_session.assert_select 'a[href=?]',edit_exercise_path(@exercise),0
      user_session.assert_select 'a[href=?]',new_exercise_solution_path(@exercise),1
      return
    elsif user.teacher?
      user_session.assert_select 'a[href=?]',edit_exercise_path(@exercise),1
      user_session.assert_select 'a[href=?]',new_exercise_solution_path(@exercise),0
      return
    end
  end
  def update_page(user,user_session)
    update_path = exercise_path(@exercise)
    title       = "$%^*&$%^&"
    content     = "0oijhg13481!@!@!@"
    if user.student?
      user_session.put update_path,exercise:{title: title,content: content}
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    assert_difference 'Exercise.count',0 do
      user_session.put update_path,exercise:{title: title,content: content}
      user_session.assert_redirected_to exercise_path(@exercise)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
      user_session.assert_select 'div',content
    end
  end
  def edit_page(user,user_session)
    edit_path = edit_exercise_path(@exercise)
    user_session.get edit_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',customized_tutorial_exercise_path(@customized_tutorial,@exercise)
    user_session.assert_template 'exercises/_form'
  end
  def create_page(user,user_session)
    create_path = customized_tutorial_exercises_path(@customized_tutorial)
    title       = "0oikjn131ijnpijsndga"
    content     = "109944"

    if user.student?
      assert_difference 'Exercise.count',0 do
        user_session.post create_path,exercise:{title: title,content: content}
        user_session.assert_redirected_to get_home_url(user)
      end
      return
    end
    assert_difference 'Exercise.count',1 do
      user_session.post create_path,exercise:{title: title,content: content}
      new_exercise = Exercise.where(title: title).order(:created_at).last
      assert new_exercise.customized_course_id == new_exercise.customized_tutorial.customized_course_id
      user_session.assert_redirected_to customized_tutorial_exercise_path(@customized_tutorial,new_exercise)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    end
  end
  def new_page(user,user_session)
    new_path     = new_customized_tutorial_exercise_path(@customized_tutorial)

    if user.student?
      user_session.get new_path
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.get new_path
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',customized_tutorial_exercises_path(@customized_tutorial)
    user_session.assert_select 'a[href=?]' ,customized_tutorial_path(@customized_tutorial)
  end
end