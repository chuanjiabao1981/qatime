require 'test_helper'
require 'models/shared/qa_issue_test'

class CourseIssueTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  include QaIssueTest


  test "course issue create" do
    customized_course       = customized_courses(:customized_course1)
    course_issue            = customized_course.course_issues.build(
        title: "title aSDFASDFA",
        content:"content IKMUJNYHFG",
        last_operator: customized_course.student
    )
    course_issue.author     = customized_course.teachers.first
    assert course_issue.valid?,course_issue.errors.full_messages
    assert_difference 'CourseIssue.count',1 do
      assert_difference 'CustomizedCourseActionRecord.count',1 do
        assert_difference 'CustomizedCourseActionNotification.count',2 do
          course_issue.save!
        end
      end
    end
  end


  test "course issue state change" do

    course_issue_for_state_change = topics(:course_issue_for_state_change)
    check_issue_state_change_process(course_issue_for_state_change)

  end

  test "course issue state cant complete" do
    course_issue_for_state_change = topics(:course_issue_for_state_change)
    check_cant_complete course_issue_for_state_change
  end

end
