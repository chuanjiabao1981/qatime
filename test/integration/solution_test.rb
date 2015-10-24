require 'sidekiq/testing'

Sidekiq::Testing.inline!


class SolutionIntegrateTest < LoginTestBase
  self.use_transactional_fixtures = true


  def setup
    super
    @homework   = examinations(:homework1)
    @exercise   = examinations(:exercise_one)
  end


  test "solution update" do
    solution     = solutions(:homework_solution_one)
    update_path  = homework_solution_path(@homework,solution)

    update_page(@student,@student_session,update_path)
    update_page(@teacher,@teacher_session,update_path)
  end
  test "solution edit" do
    solution     = solutions(:homework_solution_one)
    edit_path    = edit_solution_path(solution)

    edit_page(@student,@student_session,edit_path)
    edit_page(@teacher,@teacher_session,edit_path)
  end

  test "show page" do


    homework_solution     = solutions(:homework_solution_one)
    exercise_solution     = solutions(:exercise_solution_one)

    _show_page(@student,@student_session,homework_solution)
    _show_page(@student,@student_session,exercise_solution)
    _show_page(@teacher,@teacher_session,homework_solution)
    _show_page(@teacher,@teacher_session,exercise_solution)
  end

  test "new page" do
    new_homework_solution(@student,@student_session,@homework)
    new_homework_solution(@teacher,@teacher_session,@homework)
    new_exercise_solution(@student,@student_session,@exercise)
    new_exercise_solution(@teacher,@teacher_session,@exercise)

  end
  test "create page" do
    create_page(@student,@student_session,@homework,HomeworkSolution)
    create_page(@teacher,@teacher_session,@homework,HomeworkSolution)
    create_page(@student,@student_session,@exercise,ExerciseSolution)
    create_page(@teacher,@teacher_session,@exercise,ExerciseSolution)
  end

  private


  def update_page(user,user_session,update_path)
    solution     = solutions(:homework_solution_one)
    title        = "0ojashdbp"

    if user.teacher?
      user_session.put update_path,solution:{title: title,content: "ssddffaaa"}
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.put update_path,solution:{title: title,content: "ssddffaaa"}
    user_session.assert_redirected_to solution_path(solution)
    user_session.follow_redirect!
    user_session.assert_select 'h4',title
  end
  def edit_page(user,user_session,edit_path)
    solution     = solutions(:homework_solution_one)
    if user.teacher?
      user_session.get edit_path
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.get edit_path
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',homework_solution_path(@homework,solution)
    user_session.assert_template 'solutions/_form','solutions/edit'
  end

  def create_page(user,user_session,e,s)
    title         = "xxxxdddddfffff"
    content       = "ransdonasdkjnvsdfpkjnvdafpign"
    create_path   = send("#{e.model_name.singular_route_key}_#{e.model_name.singular_route_key}_solutions_path",e)
    user_session.post create_path, s.model_name.singular_route_key => {title: title,content: content}

    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end

    new_solution  = s.where(title: title).order(:created_at).last
    redirect_path = send "#{e.model_name.singular_route_key}_#{s.model_name.singular_route_key}_path",e,new_solution
    user_session.assert_redirected_to redirect_path #homework_solution_path(@homework,new_solution)
    user_session.follow_redirect!
    user_session.assert_select 'h4',title
  end



  def new_homework_solution(user,user_session,homework)
    _new_page(user,user_session,homework)
    if user.student?
      user_session.assert_select 'a[href=?]' , homeworks_customized_course_path(homework.customized_course),1
      user_session.assert_select 'a[href=?]' , homework_path(homework),1
    end
  end
  def new_exercise_solution(user,user_session,exercise)
    _new_page(user,user_session,exercise)
    if user.student?
      user_session.assert_select 'a[href=?]' , customized_tutorial_path(exercise.customized_tutorial),1
      user_session.assert_select 'a[href=?]' , exercise_path(exercise)
    end
  end
  def _new_page(user,user_session,e)
    new_path      = send("new_#{e.model_name.singular_route_key}_#{e.model_name.singular_route_key}_solution_path",e)
    create_path   = send("#{e.model_name.singular_route_key}_#{e.model_name.singular_route_key}_solutions_path",e)
    if user.teacher?
      user_session.get new_path
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.get new_path
    user_session.assert_response :success

    user_session.assert_select 'form[action=?]',create_path,1
    user_session.assert_response :success
    user_session.assert_template 'solutions/new','solutions/_form'
  end
  def _show_page(user,user_session,solution)
    show_path                       = send("#{solution.model_name.singular_route_key}_path",solution)
    edit_path                       = edit_solution_path(solution)
    correction_create_path          = send("#{solution.model_name.singular_route_key}_#{solution.examination.model_name.singular_route_key}_corrections_path",solution)
    correction_create_path_count    = 0
    edit_path_count                 = 0
    user_session.get show_path
    user_session.assert_response :success

    if user.teacher?
      correction_create_path_count  = 1
    elsif user.student? and user.id == solution.student_id
      edit_path_count               = 1
    end

    user_session.assert_select 'form[action=?]' ,correction_create_path,correction_create_path_count
    user_session.assert_select 'a[href=?]', edit_path,edit_path_count

  end
end