require 'test_helper'

class CourseIssueReplyTest < ActiveSupport::TestCase
  self.use_transactional_fixtures = true

  test "course issue reply create" do
    course_issue_one = topics(:course_issue_one)
    teacher            = users(:teacher1)
    assert_difference "course_issue_one.reload.replies_count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference 'ActionNotification.count',2 do
          course_issue_reply     = course_issue_one.course_issue_replies.build({content: "xxxxxxx",author: teacher})
          course_issue_reply.save!
        end
      end
    end
  end


end
