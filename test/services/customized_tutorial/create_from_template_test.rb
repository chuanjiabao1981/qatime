require 'test_helper'
require 'services/customized_tutorial/template_test'

class CreateFromTemplateTest < TemplateTest


  test "create" do
    assert_difference 'CustomizedTutorial.count',1 do
      assert_difference 'Exercise.count',@homework_count do
        assert_difference 'QaFileQuoter.count',@course_total_files_count do
          assert_difference 'PictureQuoter.count', @course_total_pictures_count do
            # CustomizedTutorial.create_from_template(@customized_course1.id,@course_one)
            CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
          end
        end
      end
    end
  end

  test "already have" do

    CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
    assert_difference 'CustomizedTutorial.count',0 do
      assert_difference 'Exercise.count',0 do
        assert_difference 'QaFileQuoter.count',0 do
          assert_difference 'PictureQuoter.count', 0 do
            CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call
          end
        end
      end
    end
  end

  test "already have but not same" do
    c = CustomizedTutorial.create(title: random_str,
                                  content: random_str,
                                  customized_course_id: @customized_course1.id,
                                  teacher_id: @course_one.author_id,
                                  last_operator_id: @course_one.author_id,
                                  template_id: @course_one.id
    )
    assert c.valid?
    # assert_not c.is_same_with_template?
    assert_not CustomizedTutorial::SameWithTemplate.new(c).judge?
    #当前的customized_course中已经有了通过course_one创建的customized_tutorial
    #不会创建新的customized_tutorial，而是进行同步
    assert_difference 'CustomizedTutorial.count',0 do
      CustomizedTutorial::CreateFromTemplate.new(@customized_course1.id,@course_one).call

      # CustomizedTutorial.create_from_template(@customized_course1.id,@course_one)
    end
    c.reload
    assert CustomizedTutorial::SameWithTemplate.new(c).judge?
  end

  test "already have a homework" do
    customized_tutorial = CustomizedTutorial.create(title: random_str,
                                                    content: random_str,
                                                    customized_course_id: @customized_course1.id,
                                                    teacher_id: @course_one.author_id,
                                                    last_operator_id: @course_one.author_id,
                                                    template_id: @course_one.id
    )
    homework = @course_one.homeworks.first
    exercise = customized_tutorial.exercises.create(customized_course_id: customized_tutorial.customized_course_id,
                                                    teacher_id:  homework.course.author_id,
                                                    last_operator_id: homework.course.author_id,
                                                    title: random_str,
                                                    content: random_str,
                                                    student_id: customized_tutorial.customized_course.student.id,
                                                    template_id: homework.id
    )
    assert exercise.valid?
    # assert_not exercise.is_same_with_template?
    assert_not Exercise::SameWithTemplate.new(exercise).judge?

    #由于存在一个exercise他的template存在了，所以会少创建一个
    assert_difference 'Exercise.count',@course_one.homeworks.count - 1 do
      CustomizedTutorial::CreateExercisesFromTemplate.new(customized_tutorial).call
      # customized_tutorial.create_exercises_from_template
    end
    exercise.reload
    # assert exercise.is_same_with_template?
    assert Exercise::SameWithTemplate.new(exercise).judge?
  end
end