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
    exercise                    = examinations(:exercise_one)
    student1                    = users(:student1)
    exercise_solution           = exercise.exercise_solutions.build(title: "123asdfds",
                                                                    content: "QERQWADFA",
                                                                    last_operator_id: student1.id )
    exercise_solution.student   = exercise.customized_course.student
    assert exercise_solution.valid?
    assert exercise_solution.customized_tutorial.valid?
    assert exercise_solution.customized_course.valid?

    assert_difference "exercise.reload.solutions_count",1 do
      assert_difference "ExerciseSolution.count",1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            exercise_solution.save!
          end
        end
      end
    end
  end

  test "create homework solution" do
    homework                        = examinations(:homework1)
    homework_solution               = homework.homework_solutions.build(title: "aodkofdo",content: "0ookmmn")
    homework_solution.student       = homework.customized_course.student
    homework_solution.last_operator = homework.customized_course.student
    assert homework_solution.valid?
    assert homework_solution.customized_course.valid?
    assert_difference "homework.reload.solutions_count",1 do
      assert_difference "HomeworkSolution.count",1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            homework_solution.save!
          end
        end
      end
    end
  end

  test "homework solution state change" do
    homework_solution                 = solutions(:homework_solution_one)
    _state_change_record(homework_solution)
  end

  test "exercise_solution state change" do
    exercise_solution                    = solutions(:exercise_solution_one)
    _state_change_record(exercise_solution)
  end

  private
  def _state_change_record(solution)
    solution.state                      = :in_progress
    teacher1                            = users(:teacher1)
    solution.last_operator              = teacher1
    solution.state_event                = :complete
    assert_difference 'CustomizedCourseStateChangeRecord.count',1 do
      assert_difference 'CustomizedCourseActionNotification.count',2 do
        solution.save
      end
    end

    a = CustomizedCourseStateChangeRecord.all.order(:created_at => :desc).first
    assert a.operator.id           == teacher1.id
    assert a.stateactionable       == solution
    a.desc
  end
end
