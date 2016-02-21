require 'test_helper'
module CustomizedTutorialServiceTest
  module FeeTest
    class AnyComponentChargedTest < ActiveSupport::TestCase
      def setup
        @customized_tutorial = customized_tutorials(:customized_tutorial_for_test_is_charged)
        assert @customized_tutorial.valid?,@customized_tutorial.errors.full_messages
      end

      test "not charged" do
        assert_not       CustomizedTutorialService::Fee::AnyComponentCharged.new(@customized_tutorial).judge?
      end

      test "tutorial charged" do
        @customized_tutorial.set_charged
        assert CustomizedTutorialService::Fee::AnyComponentCharged.new(@customized_tutorial).judge?
      end

      test "correction charged" do
        c = @customized_tutorial.exercises.first.exercise_solutions.first.exercise_corrections.first
        c.set_charged
        c.save
        @customized_tutorial.reload
        assert CustomizedTutorialService::Fee::AnyComponentCharged.new(@customized_tutorial).judge?
      end

      test "tutorial issue reply charged" do
        r = @customized_tutorial.tutorial_issues.first.tutorial_issue_replies.first
        r.set_charged
        r.save
        @customized_tutorial.reload
        assert CustomizedTutorialService::Fee::AnyComponentCharged.new(@customized_tutorial).judge?

      end
    end
  end

end