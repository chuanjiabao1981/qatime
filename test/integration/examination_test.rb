require 'sidekiq/testing'
require 'integration/shared/qa_common_state_test'

Sidekiq::Testing.inline!


class ExaminationIntegrateTest < LoginTestBase
  include QaCommonStateTest
  def setup
    super
    @customized_course    = customized_courses(:customized_course1)
    @customized_tutorial  = customized_tutorials(:customized_tutorial1)
    @homework1            = examinations(:homework1)
    @homework2            = examinations(:homework2)
    @exercise1            = examinations(:exercise_one)
  end

  test 'show page' do
    show_homework(@teacher,@teacher_session,@homework1)
    show_homework(@student,@student_session,@homework1)
    show_exercise(@teacher,@teacher_session,@exercise1)
    show_exercise(@student,@student_session,@exercise1)
  end

  test 'index page' do

    index_homework(@teacher,@teacher_session,@customized_course)
    index_homework(@student,@student_session,@customized_course)
    index_exercise(@teacher,@teacher_session,@customized_tutorial)
    index_exercise(@student,@student_session,@customized_tutorial)
  end

  test 'new page' do

    new_exercise(@teacher,@teacher_session,@customized_tutorial)
    new_exercise(@student,@student_session,@customized_tutorial)
    new_homeworks(@teacher,@teacher_session,@customized_course)
    new_homeworks(@student,@student_session,@customized_course)

  end

  test 'create page' do

    create_page(@teacher,@teacher_session,@customized_tutorial,@exercise1.class)
    create_page(@student,@student_session,@customized_tutorial,@exercise1.class)
    create_page(@teacher,@teacher_session,@customized_course,@homework1.class)
    create_page(@student,@student_session,@customized_course,@homework1.class)
  end


  test 'edit page' do
    edit_page(@teacher,@teacher_session,@customized_tutorial,@exercise1)
    edit_page(@student,@student_session,@customized_tutorial,@exercise1)
    edit_page(@teacher,@teacher_session,@customized_course,@homework1)
    edit_page(@student,@student_session,@customized_course,@homework1)
  end

  test 'update page' do

    update_page(@teacher,@teacher_session,@customized_course,@homework1)
    update_page(@student,@student_session,@customized_course,@homework1)
    update_page(@teacher,@teacher_session,@customized_tutorial,@exercise1)
    update_page(@student,@student_session,@customized_tutorial,@exercise1)
  end

  private



  def update_page(user,user_session,c,e)
    update_path     = send("#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c,e)
    redirect_path   = send("#{e.model_name.singular_route_key}_path",e)
    if user.teacher?
      title = "xdfstitleeeeeee update title update"
      user_session.put update_path,e.model_name.singular_route_key => {title: title,content: "xxxxxxxxxxxxxx"}
      user_session.assert_redirected_to redirect_path
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    else
      user_session.assert_redirected_to root_path(user)
    end
  end




  def index_exercise(user,user_session,customized_tutorial)
    user_session.get customized_tutorial_path(customized_tutorial)
    user_session.assert_response :success
    customized_tutorial.exercises.each do |e|
      user_session.assert_select 'a[href=?]',exercise_path(e),1
    end
    new_exercise_path_count = 0
    if user.teacher? and customized_tutorial.customized_course.teachers.include?(user)
      new_exercise_path_count = 1
    end

    user_session.assert_select 'a[href=?]', new_customized_tutorial_exercise_path(customized_tutorial),new_exercise_path_count

  end

  def index_homework(user,user_session,customized_course)
    user_session.get homeworks_customized_course_path(customized_course)
    user_session.assert_response :success
    customized_course.homeworks.each do |h|
      user_session.assert_select 'a[href=?]', homework_path(h),1
    end
    new_homeworks_path_count    = 0
    if user.teacher? and customized_course.teachers.include?(user)
      new_homeworks_path_count  = 1
    else
      new_homeworks_path_count  = 0
    end
    user_session.assert_select 'a[href=?]', new_customized_course_homework_path(customized_course),new_homeworks_path_count

  end
  def show_exercise(user,user_session,exercise)
    _show_page(user,user_session,exercise)
    user_session.assert_select 'a[href=?]',customized_course_path(exercise.customized_course),1
    user_session.assert_select 'a[href=?]',customized_tutorial_path(exercise.customized_tutorial),1
  end

  def show_homework(user,user_session,homework)
    _show_page(user,user_session,homework)
    user_session.assert_select 'a[href=?]',customized_course_path(homework.customized_course),1
    user_session.assert_select 'a[href=?]',homeworks_customized_course_path(homework.customized_course),1
  end

  def new_exercise(user,user_session,customized_tutorial)
    _new_page(user,user_session,customized_tutorial,Exercise)
    if not user.student?
      user_session.assert_select 'a[href=?]',customized_tutorial_path(customized_tutorial)
      user_session.assert_select 'a[href=?]',customized_course_path(customized_tutorial.customized_course)
    end
  end

  def new_homeworks(user,user_session,customized_course)
    _new_page(user,user_session,customized_course,Homework)
    if not user.student?
      user_session.assert_select 'a[href=?]',homeworks_customized_course_path(customized_course)
    end
  end

  def create_page(user,user_session,c,e)
    # 这里没有测试difference原因是，一部分在model中测试过了，更全面的是在完整的集成测试过了，所以这里就不需要了
    create_path     = send("#{c.model_name.singular_route_key}_#{e.model_name.route_key}_path",c)
    title           = "cccxxxedddwwwssssxxxxxxxxxxxx"
    content         = "oo00344ddcdagpi2er1inv"
    user_session.post create_path, e.model_name.singular_route_key => {title: title,content: content}

    if user.student?
      user_session.assert_redirected_to get_home_url(user)
    else
      new_homework    =  e.where(title: title).order(:created_at => :desc).first
      redirect_path   = send("#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c,new_homework)

      user_session.assert_redirected_to redirect_path #customized_course_homework_path(@customized_course,new_homework)
      user_session.follow_redirect!
      user_session.assert_select 'h4',title
    end
  end


  def edit_page(user,user_session,c,e)
    edit_path       = send("edit_#{e.model_name.singular_route_key}_path",e)
    update_path     = send("#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c,e)
    user_session.get edit_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    else
      user_session.assert_response :success
      user_session.assert_select 'form[action=?]',update_path
      user_session.assert_select "##{e.model_name.singular_route_key}_title" do
        user_session.assert_select '[value=?]',e.title,1
      end
    end
  end
  def _new_page(user,user_session,c,e)
    new_path        = send("new_#{c.model_name.singular_route_key}_#{e.model_name.singular_route_key}_path",c)
    create_path     = send("#{c.model_name.singular_route_key}_#{e.model_name.route_key}_path",c)
    user_session.get new_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
    else
      user_session.assert_response :success
      user_session.assert_select 'form[action=?]',create_path,1
    end
  end

  def _show_page(user,user_session,o)

    user_session.get send("#{o.model_name.singular_route_key}_path",o)
    user_session.assert_response :success
    edit_path_count           = 0
    new_solution_path_count   = 0
    if o.teacher_id == user.id
      edit_path_count = 1
    end
    if user.student?
      new_solution_path_count = 1
    end

    user_session.assert_select 'a[href=?]',send("edit_#{o.model_name.singular_route_key}_path",o),edit_path_count

    check_state_change_link(user,user_session,o,false)

    # o.solutions.each do |s|
    #   check_state_change_link(user,user_session,s,true)
    #   user_session.assert_select 'a[href=?]',send("#{s.model_name.singular_route_key}_path",s),1
    # end
    new_solution_path = send "new_#{o.model_name.singular_route_key}_#{o.model_name.singular_route_key}_solution_path", o
    user_session.assert_select 'a[href=?]',new_solution_path,new_solution_path_count

  end
end