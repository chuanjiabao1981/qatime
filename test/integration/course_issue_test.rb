require 'test_helper'

require 'sidekiq/testing'
require 'integration/shared/qa_common_state_test'


Sidekiq::Testing.inline!

class CourseIssueIntegrateTest < LoginTestBase
  self.use_transactional_tests = true
  include QaCommonStateTest


  def setup
    @customized_course    = customized_courses(:customized_course1)
    @course_issue_one   = topics(:course_issue_one)
    super
  end


  test 'new page' do
    new_path = new_customized_course_course_issue_path(@customized_course)
    new_page(@student,@student_session,new_path)
    new_page(@teacher,@teacher_session,new_path)
  end

  test 'create page' do
    create_path = customized_course_course_issues_path(@customized_course)
    create_page(@student,@student_session,create_path)
    create_page(@teacher,@teacher_session,create_path)
  end

  test 'edit page' do
    assert @course_issue_one.valid?
    edit_path = edit_customized_course_course_issue_path(@course_issue_one.customized_course,@course_issue_one)
    edit_page(@teacher,@teacher_session,edit_path)
    edit_page(@student,@student_session,edit_path)
  end

  test 'update page' do
    update_path = customized_course_course_issue_path(@course_issue_one.customized_course,@course_issue_one)
    update_page(@teacher,@teacher_session,update_path)
    update_page(@student,@student_session,update_path)
  end

  test 'show page' do
    show_path = course_issue_path(@course_issue_one)
    2.times.each do
      show_page(@teacher,@teacher_session,show_path)
      show_page(@student,@student_session,show_path)
      @course_issue_one.state = :completed
      @course_issue_one.save!
      @course_issue_one.reload
    end
  end
  private
  def show_page(user,user_session,show_path)
    user_session.get show_path
    user_session.assert_response :success

    if user.student?
      user_session.assert_select "a[href=?]",edit_course_issue_path(@course_issue_one)
    end
    new_course_issue_reply_link_count = 0
    if user.teacher?
      if @course_issue_one.can_handle?
        new_course_issue_reply_link_count = 1
      end
    end
    check_state_change_link(user,user_session,@course_issue_one,false)

    user_session.assert_select "a[href=?]",customized_course_path(@course_issue_one.customized_course),1
    user_session.assert_select "form[action=?]",course_issue_course_issue_replies_path(@course_issue_one,anchor:  "new_course_issue_reply"),new_course_issue_reply_link_count

    user_session.assert_select 'h4',@course_issue_one.title
    # if user.student?
    #   user_session.assert_select 'button','添加视频',0
    # elsif user.teacher?
    #   user_session.assert_select 'button','添加视频',1
    # end



  end
  def update_page(user,user_session,update_path)

    title       = "1aassedits234"
    content     = "1as11edit34123412s"
    user_session.put update_path, params: { course_issue: { title: title, content: content } }
    if user.teacher?
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    assert_difference 'CourseIssue.count',0 do
      assert_difference 'Topic.count',0 do
        assert_difference '@course_issue_one.customized_course.reload.course_issues_count',0 do
            user_session.put update_path, params: { course_issue:{ title: title, content: content } }
            user_session.assert_redirected_to customized_course_course_issue_path(@course_issue_one.customized_course,@course_issue_one)
            user_session.follow_redirect!
            user_session.assert_select 'h4',title
            #学生不可以回复了
            user_session.assert_select "form[action=?]",course_issue_course_issue_replies_path(@course_issue_one,anchor:  "new_course_issue_reply"),0
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
    user_session.assert_select "a[href=?]",customized_course_path(@customized_course),1
    user_session.assert_select "a[href=?]",topics_customized_course_path(@customized_course),1
    user_session.assert_select "form[action=?]",customized_course_course_issue_path(@customized_course,@course_issue_one),1

  end
  def create_page(user,user_session,create_path)
    title       = "1aasss234"
    content     = "1as1134123412s"

    if user.teacher?
      user_session.post create_path, params: { course_issue: { title: title,content: content } }
      user_session.assert_redirected_to get_home_url(user)
      return
    end
    assert_difference 'CourseIssue.count',1 do
      assert_difference 'Topic.count',1 do
        assert_difference '@customized_course.reload.course_issues_count',1 do
          assert_difference '@customized_course.reload.tutorial_issues_count',0 do

            user_session.post create_path, params: { course_issue: { title: title,content: content } }
            new_one = CourseIssue.all.order(created_at: :desc).first
            user_session.assert_redirected_to customized_course_course_issue_path(@customized_course,new_one)
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
    user_session.assert_select "a[href=?]",customized_course_path(@customized_course),1
    user_session.assert_select "a[href=?]",topics_customized_course_path(@customized_course),1
    user_session.assert_select "form[action=?]",customized_course_course_issues_path(@customized_course),1
  end
end
