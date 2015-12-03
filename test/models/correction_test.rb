require 'test_helper'
require 'tally_test_helper'
require 'models/shared/utils/qa_test_factory'

class CorrectionTest < ActiveSupport::TestCase
 include TallyTestHelper

 include QaTestFactory::QaCorrectionFactory


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


    [HomeworkCorrection, ExerciseCorrection].each do |s|
      corrections = s.by_teacher_id(teacher.id).valid_tally_unit
      keep_account_succeed(teacher, student, workstation, corrections, 5, "Correction") do
        s.by_teacher_id(teacher.id).valid_tally_unit.size
      end
    end
  end

  test 'create' do
    @solution = solutions(:homework_solution_one)
    assert @solution.valid?
    assert @solution.first_handle_created_at.nil?
    assert @solution.first_handle_author.nil?
    assert @solution.last_handle_created_at.nil?
    assert @solution.last_handle_author.nil?
    @correction         = @solution.corrections.build(content: "13412341",last_operator_id: @solution.customized_course.teachers.first.id)
    @correction.teacher = @solution.examination.teacher
    @correction.save
    assert @correction.valid?,@correction.errors.full_messages
    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction.created_at.to_i
    assert @solution.first_handle_author_id             == @correction.author.id ,"#{@solution.first_handle_author_id},#{@correction.author.id }"
    assert @solution.last_handle_created_at.to_i        == @correction.created_at.to_i
    assert @solution.last_handle_author_id              == @correction.author.id

    ## 在此提交correction，first_handle_created_at不会改变了
    sleep 1
    @correction2              = @solution.corrections.build(content: "432!@#",last_operator_id: @solution.customized_course.teachers.first.id)
    @correction2.teacher_id   = users(:teacher2).id
    @correction2.save
    assert @correction2.valid?,@correction2.errors.full_messages

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
    @correction1              = @solution.homework_corrections.build(content: "13412341",last_operator_id: @solution.examination.teacher.id)
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341",last_operator_id: @solution.examination.teacher.id)
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341",last_operator_id: @solution.examination.teacher.id)
    @correction3.teacher      = @solution.examination.teacher
    @correction3.save

    @correction2.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction1.created_at.to_i,"#{@solution.first_handle_created_at.to_i},#{@correction1.created_at.to_i}"
    assert @solution.first_handle_author_id             == @correction1.author.id
    assert @solution.last_handle_created_at.to_i        == @correction3.created_at.to_i
    assert @solution.last_handle_author_id              == @correction3.author.id

  end

  test 'destroy 3' do
    @solution                 = solutions(:homework_solution_three)
    @correction1              = @solution.homework_corrections.build(content: "13412341",last_operator_id: @solution.examination.teacher.id)
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341",last_operator_id: @solution.examination.teacher.id)
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341",last_operator_id: @solution.examination.teacher.id)
    @correction3.teacher      = @solution.examination.teacher
    @correction3.save

    @correction3.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction1.created_at.to_i,"#{@solution.first_handle_created_at} #{@correction1.created_at}"
    assert @solution.first_handle_author_id             == @correction1.author.id
    assert @solution.last_handle_created_at.to_i        == @correction2.created_at.to_i
    assert @solution.last_handle_author_id              == @correction2.author.id
  end

  test 'destroy 4' do
    @solution                 = solutions(:homework_solution_three)
    @correction1              = @solution.homework_corrections.build(content: "13412341",last_operator_id: @solution.examination.teacher.id)
    @correction1.teacher      = @solution.examination.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.homework_corrections.build(content: "13412x341",last_operator_id: @solution.examination.teacher.id)
    @correction2.teacher      = @solution.examination.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.homework_corrections.build(content: "13xxxx412341",last_operator_id: @solution.examination.teacher.id)
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
    homework_correction             = correction_build(homework_solution)
    assert homework_correction.valid?
    assert homework_correction.homework_solution.valid?
    assert homework_correction.homework.valid?
    assert homework_correction.customized_course.valid?
    assert_difference 'HomeworkCorrection.count',1 do
      assert_difference 'homework_solution.reload.corrections_count',1 do
        assert_difference 'homework_correction.homework.reload.corrections_count',1 do
          assert_difference 'CustomizedCourseActionRecord.count',2 do
            assert_difference 'CustomizedCourseActionNotification.count',4 do
              homework_correction.save
            end
          end
        end
      end
    end

    # 测试价格是否传递下去
    customized_course_prices_validation(homework_correction) do
      homework_correction.content = "134123412"
    end

  end

  test 'create exercise correction' do
    exercise_solution             = solutions(:exercise_solution_one)
    exercise_correction             = correction_build(exercise_solution)

    assert exercise_correction.valid?
    assert exercise_correction.exercise_solution.valid?
    assert exercise_correction.exercise.valid?
    assert exercise_correction.customized_course.valid?
    assert exercise_correction.customized_tutorial.valid?

    assert_difference 'ExerciseCorrection.count',1 do
      assert_difference 'exercise_correction.exercise_solution.reload.corrections_count',1 do
        assert_difference 'exercise_correction.exercise.reload.corrections_count',1 do
          assert_difference 'CustomizedCourseActionRecord.count',2 do ###这里是由于状态改变所有多了2个记录
            assert_difference 'CustomizedCourseActionNotification.count',4 do ###这里是由于状态改变所有多发了2个消息
              exercise_correction.save
            end
          end
        end
      end
    end

    # 测试价格是否传递下去
    customized_course_prices_validation(exercise_correction) do
      exercise_correction.content = "134123412"
    end

    assert exercise_solution.reload.state == "in_progress"
  end
end
