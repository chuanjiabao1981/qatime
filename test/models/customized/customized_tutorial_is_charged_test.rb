module Customized
  class CustomizedTutorialIsChargedTest  < ActiveSupport::TestCase
    def setup
      @customized_tutorial = customized_tutorials(:customized_tutorial_for_test_is_charged)
      assert @customized_tutorial.valid?
    end

    test "not charged" do
      assert_not       @customized_tutorial.is_any_component_charged?
    end

    test "tutorial charged" do
      @customized_tutorial.set_charged
      assert @customized_tutorial.is_any_component_charged?
    end

    test "correction charged" do
      c = @customized_tutorial.exercises.first.exercise_solutions.first.exercise_corrections.first
      c.set_charged
      c.save
      @customized_tutorial.reload
      assert @customized_tutorial.is_any_component_charged?
    end
  end
end