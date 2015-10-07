require 'test_helper'

class SolutionTest < ActiveSupport::TestCase
  test 'state 1' do
    solution= solutions(:homework_solution_four)
    assert solution.handle_state == :no_handle
    solution.created_at = 10.days.ago
    assert solution.handle_state == :no_handle_and_timeout
  end

  test 'state 2' do
    solution                  = solutions(:homework_solution_four)
    correction                = solution.corrections.build(content: "13412341")
    correction.teacher        = solution.solutionable.teacher
    correction.save
    solution.reload

    assert solution.handle_state == :handle_in_time

  end

  test 'state 3' do
    solution                  = solutions(:homework_solution_four)
    correction                = solution.corrections.build(content: "13412341")
    correction.teacher        = solution.solutionable.teacher
    correction.created_at     = 10.days.since
    correction.save
    solution.reload
    assert solution.handle_state == :handle_timeout

  end
end
