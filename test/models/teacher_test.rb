require 'test_helper'
require 'tally_test_helper'

class TeacherTest < ActiveSupport::TestCase
  include TallyTestHelper

  def setup
    @old =     APP_CONSTANT["price_per_minute"]
    APP_CONSTANT["price_per_minute"] = 1
  end

  def teardown
    APP_CONSTANT["price_per_minute"] = @old
  end


  test "the find or create curriculum" do
    #teacher = users(:teacher1)
    #teacher = Teacher.find(users(:teacher1).id)
    #n = Curriculum.all.size
    #s = teacher.find_or_create_curriculums
    #
    #assert n+1 == Curriculum.all.size
  end

  test "biology teacher valid" do
    biology_teacher = Teacher.find(users(:biology_teacher1).id)
    biology_teacher.valid?
    #puts biology_teacher.errors.full_messages
  end

  test "teacher keep_account" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)
    workstation = workstations(:workstation1)

    teacher_account = teacher.account
    student_account = student.account
    workstation_account = workstation.account

    teacher_money = teacher_account.money
    student_money = student_account.money
    workstation_money = workstation_account.money

    teacher_total_income = teacher_account.total_income
    teacher_total_expenditure = teacher_account.total_expenditure

    student_total_income = student_account.total_income
    student_total_expenditure = student_account.total_expenditure

    workstation_total_income = workstation_account.total_income
    workstation_total_expenditure = workstation_account.total_expenditure


    # 计算预期的钱的变化值
    student_money_change_expected = 0
    teacher_money_change_expected = 0
    workstation_money_change_expected = 0

    [CustomizedTutorial, HomeworkCorrection,ExerciseCorrection].each do |s|
      assert s.by_teacher_id(teacher.id).valid_tally_unit.size == 5
      s.by_teacher_id(teacher.id).valid_tally_unit.each do |object|
        fee_value, teacher_value, workstation_value = calculate_test_expected_money_change_value(object)
        student_money_change_expected += fee_value
        teacher_money_change_expected += teacher_value
        workstation_money_change_expected += workstation_value
      end
    end

    [TutorialIssueReply, CourseIssueReply].each do |s|
      assert s.by_author_id(teacher.id).valid_tally_unit.size == 5
      s.by_author_id(teacher.id).valid_tally_unit.each do |object|
        fee_value, teacher_value, workstation_value = calculate_test_expected_money_change_value(object)
        student_money_change_expected += fee_value
        teacher_money_change_expected += teacher_value
        workstation_money_change_expected += workstation_value
      end
    end

    teacher.keep_account

    [CustomizedTutorial, HomeworkCorrection,ExerciseCorrection].each do |s|
      assert s.by_teacher_id(teacher.id).valid_tally_unit.size == 0
    end

    [TutorialIssueReply, CourseIssueReply].each do |s|
      assert s.by_author_id(teacher.id).valid_tally_unit.size == 0
    end

    customized_course     = customized_courses(:customized_course_tally)
    assert customized_course.fees.size == 25
    customized_course.fees.each do |f|
      assert f.consumption_records.length           == 1
      assert f.consumption_records.first.account_id == student.account.id
      assert f.consumption_records.first.value      == f.value

      teacher_percent, workstation_percent = calculate_test_split_percents(f)
      teacher_earning_value = float_test_format(f.value * teacher_percent)
      workstation_earning_value = float_test_format(f.value * workstation_percent)

      assert f.earning_records.length               == 2
      assert f.earning_records.first.account_id     == teacher.account.id
      assert f.earning_records.first.price          == customized_course.teacher_price
      assert f.earning_records.first.value          == teacher_earning_value
      assert f.earning_records.second.account_id    == workstation.account.id
      assert f.earning_records.second.price         == customized_course.platform_price
      assert f.earning_records.second.value         == workstation_earning_value

      assert f.value == float_test_format(f.earning_records.first.value + f.earning_records.second.value)
      assert f.video_duration   == f.feeable.video.duration
    end

    teacher_account.reload
    student_account.reload
    workstation_account.reload

    assert teacher_account.money == float_test_format(teacher_money + teacher_money_change_expected)
    assert student_account.money == float_test_format(student_money - student_money_change_expected)

    assert workstation_account.money == float_test_format(workstation_money + workstation_money_change_expected)

    assert teacher_account.total_income ==  float_test_format(teacher_total_income + teacher_money_change_expected)
    assert teacher_account.total_expenditure == teacher_total_expenditure

    assert student_account.total_income == student_total_income
    assert student_account.total_expenditure == float_test_format(student_total_expenditure + student_money_change_expected)

    assert workstation_account.total_income == float_test_format(workstation_total_income + workstation_money_change_expected)
    assert workstation_account.total_expenditure == workstation_total_expenditure
  end
end
