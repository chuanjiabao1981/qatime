require 'test_helper'

class TutorialIssueTest < ActiveSupport::TestCase
  test "token is exsits" do
    customized_tutorial = customized_tutorials(:customized_tutorial1)
    assert customized_tutorial.valid?
    a                   = customized_tutorial.tutorial_issues.build
    assert_not a.token.nil?
    assert a.customized_course.valid?
  end
end
