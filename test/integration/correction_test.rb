require 'sidekiq/testing'

Sidekiq::Testing.inline!


class CorrectionIntegrateTest < LoginTestBase

  def setup
    super
    @solution     = solutions(:homework_solution_one)
  end




  test 'correction create' do

    create_page(@teacher,@teacher_session)
    create_page(@student,@student_session)

  end

  test 'correction edit' do
    edit_path(@teacher,@teacher_session)
    edit_path(@student,@student_session)
  end

  test 'correction update' do
    update_path(@teacher,@teacher_session)
    update_path(@student,@student_session)
  end

  private

  def update_path(user,user_session)

    correction   = corrections(:correction_one)
    update_path  = solution_correction_path(@solution,correction)
    content      ="!@#$!@#%!@#$!@#$!SDFGADGASDFAS"
    user_session.put update_path,correction:{content: content}

    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_redirected_to solution_path(@solution)
    user_session.follow_redirect!
    user_session.assert_select 'div',content
  end
  def edit_path(user,user_session)
    correction   = corrections(:correction_one)
    edit_path    = edit_correction_path(correction)
    user_session.get edit_path
    if user.student?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_select 'form[action=?]',solution_correction_path(@solution,correction)
    user_session.assert_response :success

  end
  def create_page(user,user_session)
    create_path = solution_corrections_path(@solution)
    content      = "oasdfasdfe134513413451"
    if user.student?
      assert_difference 'Correction.count',0 do
        user_session.post create_path,correction:{content: content}
        user_session.assert_redirected_to get_home_url(user)
      end
      return
    end
    assert_difference 'Correction.count',1 do
      user_session.post create_path,correction:{content: content}
      new_correction = @solution.corrections.order(created_at: :asc).last

      assert new_correction.customized_course_id == @solution.customized_course_id,"not equal"
      user_session.assert_redirected_to solution_path(@solution)
      user_session.follow_redirect!
      user_session.assert_select 'div',new_correction.content
    end
  end
end