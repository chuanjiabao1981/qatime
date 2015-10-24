require 'test_helper'

class SolutionTest < ActiveSupport::TestCase

  self.use_transactional_fixtures = true

  test 'state 1' do
    solution= solutions(:homework_solution_four)
    assert solution.handle_state == :no_handle
    solution.created_at = 10.days.ago
    assert solution.handle_state == :no_handle_and_timeout
  end

  test 'state 2' do
    solution                  = solutions(:homework_solution_four)
    correction                = solution.corrections.build(content: "13412341")
    correction.teacher        = solution.examination.teacher
    correction.save
    solution.reload

    assert solution.handle_state == :handle_in_time

  end

  test 'state 3' do
    solution                  = solutions(:homework_solution_four)
    correction                = solution.corrections.build(content: "13412341")
    correction.teacher        = solution.examination.teacher
    correction.created_at     = 10.days.since
    correction.save
    solution.reload
    assert solution.handle_state == :handle_timeout

  end

  test "create exercise solution" do
    exercise            = examinations(:exercise_one)
    exercise_solution   = exercise.exercise_solutions.build(title: "123asdfds",content: "QERQWADFA")

    assert exercise_solution.valid?
    assert exercise_solution.customized_tutorial.valid?
    assert exercise_solution.customized_course.valid?

    assert "exercise.reload.solutions_count",1 do
      assert "Exercise.count",1 do
        exercise_solution.save!
      end
    end
  end

  test "create homework solution" do
    homework            = examinations(:homework1)
    homework_solution   = homework.homework_solutions.build(title: "aodkofdo",content: "0ookmmn")

    assert homework_solution.valid?
    assert homework_solution.customized_course.valid?
    assert "homework.reload.solutions_count",1 do
      assert "Homework.count",1 do
        homework_solution.save!
      end
    end
  end
end
