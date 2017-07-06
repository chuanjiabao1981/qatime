require 'sidekiq/testing'
require 'integration/shared/qa_common_state_test'


Sidekiq::Testing.inline!


class SolutionIntegrateTest < LoginTestBase
  include QaCommonStateTest

  self.use_transactional_fixtures = true


  def setup
    super
    @homework   = examinations(:homework1)
    @exercise   = examinations(:exercise_one)
  end


  test "update page" do
    homework_solution     = solutions(:homework_solution_one)
    exercise_solution     = solutions(:exercise_solution_one)

    update_page(@student,@student_session,homework_solution)
    update_page(@teacher,@teacher_session,homework_solution)
    update_page(@student,@student_session,exercise_solution)
    update_page(@teacher,@teacher_session,exercise_solution)

  end
  test "edit page" do
    homework_solution     = solutions(:homework_solution_one)
    exercise_solution     = solutions(:exercise_solution_one)

    edit_page(@student,@student_session,homework_solution)
    edit_page(@teacher,@teacher_session,homework_solution)
    edit_page(@student,@student_session,exercise_solution)
    edit_page(@teacher,@teacher_session,exercise_solution)
  end

  test "show page" do


    homework_solution     = solutions(:homework_solution_one)
    exercise_solution     = solutions(:exercise_solution_one)

    2.times do
      _show_page(@student,@student_session,homework_solution)
      _show_page(@student,@student_session,exercise_solution)
      _show_page(@teacher,@teacher_session,homework_solution)
      _show_page(@teacher,@teacher_session,exercise_solution)

      # 测试当solution完毕的completed的时候页面的状态
      exercise_solution.state = :completed
      homework_solution.state = :completed
      exercise_solution.save!
      homework_solution.save!
    end
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


  def update_page(user,user_session,solution)

    update_path                     = send "#{solution.examination.model_name.singular_route_key}_#{solution.model_name.singular_route_key}_path",solution.examination,solution
    redirect_path                   = send "#{solution.model_name.singular_route_key}_path",solution
    title                           = "0ojashdbp"
    user_session.put update_path, solution.model_name.singular_route_key  => {title: title,content: "ssddffaaa"}

    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_redirected_to redirect_path
    user_session.follow_redirect!
    user_session.assert_select 'h4',title
  end
  def edit_page(user,user_session,solution)

    edit_path                       = edit_solution_path(solution)
    update_path                     = send "#{solution.examination.model_name.singular_route_key}_#{solution.model_name.singular_route_key}_path",solution.examination,solution
    user_session.get edit_path
    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select 'form[action=?]',update_path
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
    correction_create_path          =
        send("#{solution.model_name.singular_route_key}_#{solution.examination.model_name.singular_route_key}_corrections_path",solution,
             anchor: "new_#{solution.examination.model_name.singular_route_key}_correction")
    correction_create_path_count    = 0
    edit_path_count                 = 0
    user_session.get show_path
    user_session.assert_response :success

    check_state_change_link(user,user_session,solution,true)

    if user.teacher?
      if solution.can_handle?
        correction_create_path_count  = 1
      else
        correction_create_path_count  = 0
      end
    elsif user.student? and user.id == solution.student_id
      edit_path_count               = 1
    end


    solution.corrections.each do |c|
      if c.teacher.id == user.id
        user_session.assert_select 'a[href=?]',edit_correction_path(c),1
      end
    end

    user_session.assert_select 'form[action=?]' ,correction_create_path,correction_create_path_count
    user_session.assert_select 'a[href=?]', edit_path,edit_path_count

  end
end