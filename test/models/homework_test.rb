require 'test_helper'
require 'models/shared/qa_common_state_test'
require 'models/shared/qa_examination_test'
require 'models/shared/utils/qa_test_factory'


class HomeworkTest < ActiveSupport::TestCase

  include QaCommonStateTest
  include QaExaminationTest

  self.use_transactional_fixtures = true

  test "validate" do
    homework1 = examinations(:homework1)

    assert homework1.valid?,homework1.errors.full_messages
  end

  test "create" do
    customized_course       = customized_courses(:customized_course1)
    homework                = customized_course.homeworks.build(title: "1234123",content: "1341234-------")
    homework.teacher        = customized_course.teachers.first
    homework.last_operator  = customized_course.teachers.first
    assert homework.valid?
    assert homework.customized_course.valid?

    assert_difference 'Homework.count',1 do
      assert_difference 'homework.customized_course.reload.homeworks_count',1 do
        assert_difference 'CustomizedCourseActionRecord.count',1 do
          #两个老师所以2
          assert_difference 'CustomizedCourseActionNotification.count',2 do
            homework.save
          end
        end
      end
    end
  end

  test "homework state change notification" do
    homework1                 = examinations(:homework_for_state_change)
    QaTestFactory::QaSolutionFactory.create homework1,completed: true
    homework1.reload
    check_state_change_record(homework1)
  end



  test "homework state change process" do
    homework1                 = examinations(:homework_for_state_change)
    check_examination_state_change_process(homework1)
  end


  test "homework cant complete 1" do
    homework1                 = examinations(:homework_for_state_change)
    check_cant_complete_1 homework1
  end

  test "homework cant complete 2" do
    homework1                 = examinations(:homework_for_state_change)
    check_cant_complete_2(homework1)
  end


end
