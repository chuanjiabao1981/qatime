require 'test_helper'

require 'sidekiq/testing'
require 'integration/shared/qa_common_state_test'


Sidekiq::Testing.inline!

class TutorialIssueIntegrateTest < LoginTestBase
  include QaCommonStateTest

  self.use_transactional_tests = true

  def setup
    @customized_tutorial = customized_tutorials(:customized_tutorial1)
    @tutorial_issue_one = topics(:tutorial_issue_one)
    super
  end


  test 'new page' do
    new_page(@student,@student_session,new_customized_tutorial_tutorial_issue_path(@customized_tutorial))
    new_page(@teacher,@teacher_session,new_customized_tutorial_tutorial_issue_path(@customized_tutorial))
  end

  test 'create page' do
    create_page(@student,@student_session,customized_tutorial_tutorial_issues_path(@customized_tutorial))
    create_page(@teacher,@teacher_session,customized_tutorial_tutorial_issues_path(@customized_tutorial))
  end

  test 'edit page' do
    assert @tutorial_issue_one.valid?

    edit_page(@teacher,@teacher_session,edit_customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,@tutorial_issue_one))
    edit_page(@student,@student_session,edit_customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,@tutorial_issue_one))
  end

  test 'update page' do

    update_page(@teacher,@teacher_session,customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,@tutorial_issue_one))
    update_page(@student,@student_session,customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,@tutorial_issue_one))
  end

  test 'show page' do
    2.times.each do
      show_page(@teacher,@teacher_session,tutorial_issue_path(@tutorial_issue_one))
      show_page(@student,@student_session,tutorial_issue_path(@tutorial_issue_one))
      @tutorial_issue_one.state = :completed
      @tutorial_issue_one.save!
      @tutorial_issue_one.reload
    end

  end
  private
  def show_page(user,user_session,show_path)
    user_session.get show_path
    user_session.assert_response :success,"#{user.role},#{@tutorial_issue_one.to_json}"
    # puts user_session.response.body

    if user.student?
      user_session.assert_select "a[href=?]",edit_tutorial_issue_path(@tutorial_issue_one)
    end
    new_issue_repliy_link = 0
    if user.teacher?
      if @tutorial_issue_one.can_handle?
        new_issue_repliy_link = 1
      end
    end
    check_state_change_link(user,user_session,@tutorial_issue_one,false)

    user_session.assert_select "a[href=?]",customized_tutorial_path(@tutorial_issue_one.customized_tutorial),1
    user_session.assert_select "a[href=?]",customized_course_path(@tutorial_issue_one.customized_tutorial.customized_course),1
    user_session.assert_select "form[action=?]",tutorial_issue_tutorial_issue_replies_path(@tutorial_issue_one,anchor:  "new_tutorial_issue_reply"),new_issue_repliy_link
    user_session.assert_select 'h4',@tutorial_issue_one.title

  end
  def update_page(user,user_session,update_path)

    title       = "1aassedits234"
    content     = "1as11edit34123412s"
    user_session.put update_path, params: { tutorial_issue: { title: title,content: content } }
    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    assert_difference 'TutorialIssue.count',0 do
      assert_difference 'Topic.count',0 do
        assert_difference '@tutorial_issue_one.customized_tutorial.reload.tutorial_issues_count',0 do
          assert_difference '@tutorial_issue_one.customized_tutorial.reload.customized_course.tutorial_issues_count',0 do
            user_session.put update_path, params: { tutorial_issue: { title: title,content: content } }
            user_session.assert_redirected_to customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,@tutorial_issue_one)
            user_session.follow_redirect!
            user_session.assert_select 'h4',title
            #学生不允许解答问题
            user_session.assert_select "form[action=?]",tutorial_issue_tutorial_issue_replies_path(@tutorial_issue_one,anchor:  "new_tutorial_issue_reply"),0
          end
        end
      end
    end
  end
  def edit_page(user,user_session,edit_path)

    user_session.get edit_path
    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select "a[href=?]",customized_tutorial_path(@tutorial_issue_one.customized_tutorial),1
    user_session.assert_select "a[href=?]",customized_course_path(@tutorial_issue_one.customized_tutorial.customized_course),1
    user_session.assert_select "form[action=?]",customized_tutorial_tutorial_issue_path(@tutorial_issue_one.customized_tutorial,
                                                                                        @tutorial_issue_one),1
  end
  def create_page(user,user_session,create_path)
    title       = "1aasss234"
    content     = "1as1134123412s"

    if user.teacher?
      user_session.post create_path, params: { tutorial_issue: { title: title,content: content } }
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    assert_difference 'TutorialIssue.count',1 do
      assert_difference 'Topic.count',1 do
        assert_difference '@customized_tutorial.reload.tutorial_issues_count',1 do
          assert_difference '@customized_tutorial.reload.customized_course.tutorial_issues_count', 1 do
            user_session.post create_path, params: { tutorial_issue: { title: title,content: content } }
            new_one = TutorialIssue.all.order(created_at: :desc).first
            user_session.assert_redirected_to customized_tutorial_tutorial_issue_path(@customized_tutorial,new_one)
            user_session.follow_redirect!

            user_session.assert_select 'h4',title
          end
        end
      end
    end

  end
  def new_page(user,user_session,new_path)
    user_session.get new_path

    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    user_session.assert_response :success
    user_session.assert_select "a[href=?]",customized_tutorial_path(@customized_tutorial),1
    user_session.assert_select "a[href=?]",customized_course_path(@customized_tutorial.customized_course),1
    user_session.assert_select "form[action=?]",customized_tutorial_tutorial_issues_path(@customized_tutorial),1
  end
end
