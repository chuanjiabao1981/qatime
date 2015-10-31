require 'test_helper'
require 'tally_test_helper'

class CorrectionTest < ActiveSupport::TestCase
 include TallyTestHelper

  # test "the truth" do
  #   assert true
  # end

  def setup
    @old =     APP_CONSTANT["price_per_minute"]

    APP_CONSTANT["price_per_minute"] = 1
  end

  def teardown
    APP_CONSTANT["price_per_minute"] = @old
  end

  # 测试记账功能
  test "correction keep_account" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)
    workstation = workstations(:workstation1)
    corrections = HomeworkCorrection.by_teacher_id(teacher.id).valid_tally_unit

    keep_account_succeed(teacher, student, corrections, 5) do
      HomeworkCorrection.by_teacher_id(teacher.id).valid_tally_unit.size
    end
  end

  test 'create' do
    @solution = solutions(:homework_solution_one)
    assert @solution.valid?
    assert @solution.first_handle_created_at.nil?
    assert @solution.first_handle_author.nil?
    assert @solution.last_handle_created_at.nil?
    assert @solution.last_handle_author.nil?
    @correction         = @solution.corrections.build(content: "13412341")
    # 测试价格是否传递下去
    customized_course_prices_validation(@correction) do
      @correction.content = "134123412"
    end

    @correction.teacher = @solution.examination.teacher
    @correction.save
    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction.created_at.to_i
    assert @solution.first_handle_author_id             == @correction.author.id
    assert @solution.last_handle_created_at.to_i        == @correction.created_at.to_i
    assert @solution.last_handle_author_id              == @correction.author.id

    ## 在此提交correction，first_handle_created_at不会改变了
    sleep 1
    @correction2              = @solution.corrections.build(content: "432!@#")
    @correction2.teacher_id   = users(:teacher2).id
    @correction2.save
    @solution.reload

    assert      @solution.first_handle_created_at.to_i       == @correction.created_at.to_i
    assert      @solution.first_handle_author_id             == @correction.author.id
    assert_not  @solution.first_handle_created_at.to_i       == @correction2.created_at.to_i
    assert_not  @solution.first_handle_author_id             == @correction2.author.id
    assert      @solution.last_handle_created_at.to_i        == @correction2.created_at.to_i
    assert      @solution.last_handle_author_id              == @correction2.author.id

  end

  test 'destroy 1' do
    @solution = solutions(:homework_solution_two)
    @correction         = @solution.corrections.build(content: "13412341")
    @correction.teacher = @solution.examination.teacher
    @correction.save
    @solution.reload
    @correction.destroy
    @solution.reload
    assert @solution.first_handle_created_at.nil?
    assert @solution.first_handle_author_id.nil?
    assert @solution.last_handle_created_at.nil?
    assert @solution.last_handle_author_id.nil?
  end

  test 'destroy 2' do
    @solution                 = solutions(:homework_solution_three)
    @correction1              = @solution.homework_corrections.build(content: "13412341")
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.examination.teacher
    @correction3.save

    @correction2.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction1.created_at.to_i
    assert @solution.first_handle_author_id             == @correction1.author.id
    assert @solution.last_handle_created_at.to_i        == @correction3.created_at.to_i
    assert @solution.last_handle_author_id              == @correction3.author.id

  end

  test 'destroy 3' do
    @solution                 = solutions(:homework_solution_three)
    @correction1              = @solution.homework_corrections.build(content: "13412341")
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.examination.teacher
    @correction3.save

    @correction3.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction1.created_at.to_i
    assert @solution.first_handle_author_id             == @correction1.author.id
    assert @solution.last_handle_created_at.to_i        == @correction2.created_at.to_i
    assert @solution.last_handle_author_id              == @correction2.author.id
  end

  test 'destroy 4' do
    @solution                 = solutions(:homework_solution_three)
    @correction1              = @solution.homework_corrections.build(content: "13412341")
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.examination.teacher
    @correction3.save

    @correction1.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction2.created_at.to_i
    assert @solution.first_handle_author_id             == @correction2.author.id
    assert @solution.last_handle_created_at.to_i        == @correction3.created_at.to_i
    assert @solution.last_handle_author_id              == @correction3.author.id
  end


  test 'create homework correction' do
    homework_solution               = solutions(:homework_solution_one)
    homework_correction             = homework_solution.homework_corrections.build(content: "!234134asdasdfads")
    homework_correction.teacher     = homework_solution.examination.teacher
    assert homework_correction.valid?
    assert homework_correction.homework_solution.valid?
    assert homework_correction.homework.valid?
    assert_difference 'HomeworkCorrection.count',1 do
      assert_difference 'homework_solution.reload.corrections_count',1 do
        assert_difference 'homework_correction.homework.reload.corrections_count',1 do
          homework_correction.save
        end
      end
    end
  end

  test 'create exercise correction' do
    exercise_solution             = solutions(:exercise_solution_one)
    exercise_correction           = exercise_solution.exercise_corrections.build(content: "13445363456")
    exercise_correction.teacher   = exercise_solution.examination.teacher
    assert exercise_correction.valid?
    assert exercise_correction.exercise_solution.valid?
    assert exercise_correction.exercise.valid?
    assert exercise_correction.customized_course.valid?
    assert exercise_correction.customized_tutorial.valid?

    assert_difference 'ExerciseCorrection.count',1 do
      assert_difference 'exercise_correction.exercise_solution.reload.corrections_count',1 do
        assert_difference 'exercise_correction.exercise.reload.corrections_count',1 do
          exercise_correction.save
        end
      end
    end
  end
end
