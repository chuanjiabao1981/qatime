require 'test_helper'
class AnyComponentChargedTest < ActiveSupport::TestCase

  def setup
    @customized_tutorial = customized_tutorials(:customized_tutorial_for_test_is_charged)
    assert @customized_tutorial.valid?
  end

  test "not charged" do
    assert_not       CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?
  end

  test "tutorial charged" do
    @customized_tutorial.set_charged
    assert CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?
  end

  test "correction charged" do
    c = @customized_tutorial.exercises.first.exercise_solutions.first.exercise_corrections.first
    c.set_charged
    c.save
    @customized_tutorial.reload
    assert CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?
  end

  test "tutorial issue reply charged" do
    r = @customized_tutorial.tutorial_issues.first.tutorial_issue_replies.first
    r.set_charged
    r.save
    @customized_tutorial.reload
    assert CustomizedTutorial::AnyComponentCharged.new(@customized_tutorial).judge?

  end
end