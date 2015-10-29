require 'test_helper'

class CourseIssueTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "course issue create" do
    customized_course       = customized_courses(:customized_course1)
    course_issue            = customized_course.course_issues.build(title: "title aSDFASDFA",content:"content IKMUJNYHFG")
    course_issue.author     = customized_course.teachers.first
    assert course_issue.valid?,course_issue.errors.full_messages
    assert_difference 'CourseIssue.count',1 do
      assert_difference 'CustomizedCourseActionRecord.count',1 do
        course_issue.save!
      end
    end
  end


end
