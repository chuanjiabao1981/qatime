require 'test_helper'

class CommentTest < ActiveSupport::TestCase


  test "homework correction comment" do
    homework_correction                   = corrections(:correction_one)
    homework_correction_comment           = homework_correction.comments.build(content: "asdfasdfafds")
    homework_correction_comment.author    = homework_correction.teacher
    assert     homework_correction.valid?
    assert_not homework_correction_comment.customized_course.nil?
    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          homework_correction_comment.save
        end
      end
    end
  end

  test "exercise correction comment" do
    exercise_correction                   = corrections(:correction_two)
    exercise_correction_comment           = exercise_correction.comments.build(content: "xcvdqsefq")
    exercise_correction_comment.author    = exercise_correction.teacher
    assert      exercise_correction_comment.valid?
    assert_not  exercise_correction_comment.customized_course.nil?
    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          exercise_correction_comment.save
        end
      end
    end
  end

  test "homework solution comment" do
    homework_solution                    = solutions(:homework_solution_one)
    homework_solution_comment            = homework_solution.comments.build(content: "okooin")
    homework_solution_comment.author     = homework_solution.student
    assert        homework_solution_comment.valid?
    assert_not    homework_solution_comment.customized_course.nil?
    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          homework_solution_comment.save
        end
      end
    end
  end

  test "exercise solution comment" do
    exercise_solution                   = solutions(:exercise_solution_one)
    exercise_solution_comment           = exercise_solution.comments.build(content: "sdafsdfasd")
    exercise_solution_comment.author    = exercise_solution.student
    assert        exercise_solution_comment.valid?
    assert_not    exercise_solution_comment.customized_course.nil?
    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          exercise_solution_comment.save
        end
      end
    end
  end

  test "homework comment" do
    homework                           = examinations(:homework1)
    homework_comment                   = homework.comments.build(content: "12341234")
    homework_comment.author            = homework.teacher
    assert        homework_comment.valid?
    assert_not    homework_comment.customized_course.nil?
    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          homework_comment.save
        end
      end
    end
  end

  test "exercise comment" do
    exercise                          = examinations(:exercise_one)
    exercise_comment                  = exercise.comments.build(content: "1234123412")
    exercise_comment.author           = exercise.teacher
    assert            exercise_comment.valid?
    assert_not        exercise_comment.customized_course.nil?

    assert_difference "Comment.count",1 do
      assert_difference "CustomizedCourseActionRecord.count",1 do
        assert_difference "CustomizedCourseActionNotification.count",2 do
          exercise_comment.save
        end
      end
    end

  end




end
