require 'test_helper'

class ExcerciseTest < ActiveSupport::TestCase
  test "build" do
    @customized_tutorial = customized_tutorials(:customized_tutorial1)

    exercise             = @customized_tutorial.exercises.build(title: "1234",content: "12341")
    assert exercise.valid?
    assert exercise.customized_course.valid?
    assert exercise.customized_tutorial.valid?
    assert_difference '@customized_tutorial.reload.exercises_count',1 do
      assert_difference '@customized_tutorial.customized_course.reload.exercises_count',1 do
        exercise.save!
      end
    end
  end
end
