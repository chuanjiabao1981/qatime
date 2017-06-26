require 'sidekiq/testing'

Sidekiq::Testing.inline!


class CorrectionIntegrateTest < LoginTestBase

  def setup
    super
    @solution               = solutions(:homework_solution_one)
    @exercise_solution      = solutions(:exercise_solution_one)
    assert @exercise_solution.valid?
  end

  test 'create page' do

    _create_page(@teacher,@teacher_session,@solution,HomeworkCorrection)
    _create_page(@teacher,@teacher_session,@exercise_solution,ExerciseCorrection)

    _create_page(@student,@student_session,@solution,HomeworkCorrection)
    _create_page(@student,@student_session,@exercise_solution,ExerciseCorrection)


  end

  test 'edit page' do
    homework_correction = corrections(:correction_one)
    exercise_correction = corrections(:correction_two)
    edit_homework_correction(@student,@student_session,homework_correction)
    edit_homework_correction(@teacher,@teacher_session,homework_correction)
    edit_exercise_correction(@student,@student_session,exercise_correction)
    edit_exercise_correction(@teacher,@teacher_session,exercise_correction)
  end

  test 'update page' do
    homework_correction = corrections(:correction_one)
    exercise_correction = corrections(:correction_two)
    update_path(@teacher,@teacher_session,homework_correction.homework_solution,homework_correction)
    update_path(@student,@student_session,homework_correction.homework_solution,homework_correction)
    update_path(@teacher,@teacher_session,exercise_correction.exercise_solution,exercise_correction)
    update_path(@student,@student_session,exercise_correction.exercise_solution,exercise_correction)
  end

  private

  def update_path(user,user_session,solution,correction)
    update_path       = send "#{solution.model_name.singular_route_key}_#{correction.model_name.singular_route_key}_path",solution,correction
    redirected_path   = solution_path(solution)
    content      ="!@#$!@#%!@#$!@#$!SDFGADGASDFAS"
    user_session.put update_path,correction.model_name.singular_route_key => {content: content}

    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end

    user_session.assert_redirected_to redirected_path
    user_session.follow_redirect!
    user_session.assert_select 'div',content
  end



  def edit_homework_correction(user,user_session,homework_correction)
    _edit_page(user,user_session,homework_correction.homework_solution,homework_correction)
    if user.teacher?
      user_session.assert_select 'a[href=?]',homeworks_customized_course_path(homework_correction.homework_solution.customized_course)
      user_session.assert_select 'a[href=?]',homework_path(homework_correction.homework)
      user_session.assert_select 'a[href=?]',homework_solution_path(homework_correction.homework_solution)
    end
  end
  def edit_exercise_correction(user,user_session,exercise_correction)
    _edit_page(user,user_session,exercise_correction.exercise_solution,exercise_correction)
    if user.teacher?
      user_session.assert_select 'a[href=?]',customized_tutorial_path(exercise_correction.customized_tutorial)
      user_session.assert_select 'a[href=?]',exercise_solution_path(exercise_correction.exercise_solution)
    end
  end
  def _edit_page(user,user_session,solution,correction)
    edit_path         = edit_correction_path(correction)
    update_path       = send "#{correction.model_name.singular_route_key}_path",correction
    user_session.get edit_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_select 'form[action=?]',update_path
    user_session.assert_response :success
  end

  def _create_page(user,user_session,solution,correction)

    create_path           = send "#{solution.model_name.singular_route_key}_#{correction.model_name.route_key}_path",solution
    redirect_path         = solution_path(solution)
    content               = "1341241234124"
    user_session.post create_path,correction.model_name.singular_route_key => {content: content}
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_redirected_to redirect_path
    user_session.follow_redirect!
    user_session.assert_select 'div',content
  end
end