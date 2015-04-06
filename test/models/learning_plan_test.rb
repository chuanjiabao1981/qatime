require 'test_helper'

class LearningPlanTest < ActiveSupport::TestCase
  test "the truth" do
    a = learning_plans(:h_math_learning_plan)
    assert a.valid?
    assert a.teachers.length == 2
  end
end
