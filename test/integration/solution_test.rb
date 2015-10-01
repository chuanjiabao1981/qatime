require 'sidekiq/testing'

Sidekiq::Testing.inline!


class SolutionIntegrateTest < LoginTestBase


  def setup
    super
    @homework = homeworks(:homework1)
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

  test "solution show" do
    solution     = solutions(:homework_solution_one)

    show_path    = solution_path(solution)
    show_page(@student,@student_session,show_path)
    show_page(@teacher,@teacher_session,show_path)
  end

  test "solution new" do
    new_path     = new_homework_solution_path(@homework)
    new_page(@student,@student_session,new_path)
    new_page(@teacher,@teacher_session,new_path)
  end
  test "solution create" do
    create_path  = homework_solutions_path(@homework)
    create_page(@student,@student_session,create_path)
    create_page(@teacher,@teacher_session,create_path)
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

  def show_page(user,user_session,show_path)
    solution     = solutions(:homework_solution_one)
    correction   = corrections(:correction_one)
    assert correction.valid?
    user_session.get show_path
    user_session.assert_response :success
    user_session.assert_select 'a[href=?]' ,homework_path(@homework),1
    if user.teacher?
      user_session.assert_select 'a[href=?]' ,edit_solution_path(solution),0
      user_session.assert_select 'form[action=?]' , solution_corrections_path(solution),1
    elsif user.student?
      user_session.assert_select 'a[href=?]' ,edit_solution_path(solution),1
      user_session.assert_select 'form[action=?]' , solution_corrections_path(solution),0

    end
    user_session.assert_select 'h4' , solution.title
    user_session.assert_select 'div',correction.content


  end
  def new_page(user,user_session,new_path)
    if user.teacher?
      user_session.get new_path
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.get new_path
    user_session.assert_response :success

    user_session.assert_select 'form[action=?]',homework_solutions_path(@homework),1
    user_session.assert_response :success
    user_session.assert_template 'solutions/new','solutions/_form'
  end
  def create_page(user,user_session,create_path)
    title        = "xxxxdddddfffff"

    if user.teacher?
      assert_difference "Solution.count",0 do
        user_session.post create_path, solution:{title: title,content: "22233442"}
        user_session.assert_redirected_to get_home_url(user)
      end
      return
    end

    assert_difference 'Solution.count',1 do
      user_session.post create_path, solution:{title: title,content: "22233442"}
      new_solution = Solution.where(title: title).order(:created_at).last
      #这里假设solutionable是给homework不是exercise
      assert new_solution.customized_course_id == new_solution.solutionable.customized_course_id
      user_session.assert_redirected_to homework_solution_path(@homework,new_solution)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    end
  end
end