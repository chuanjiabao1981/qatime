require 'test_helper'

class CorrectionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # 测试记账功能
  test "correction keep_account" do
    #

    teacher = Teacher.find(users(:teacher1).id)

    print Correction.by_teacher(teacher.id).valid_tally_unit.size
    assert Correction.by_teacher(teacher.id).valid_tally_unit.size == 3

    correction = corrections(:correction_two)

    video = videos(:correction_two_video)
    assert correction.token == video.token
    assert correction.valid?,correction.errors.full_messages
    assert video.valid?,video.errors.full_messages

    assert_not_nil video
    assert correction.video == video

    correction.keep_account(teacher.id)
    correction_1 = corrections(:correction_three)
    correction_1.keep_account(teacher.id)

    # 帐号发生了变化
    # 生成了fee
    student = Student.find(users(:student1).id)
    assert teacher.account.money == 2.7
    assert student.account.money == -2.7

    fee = correction_1.fee
    assert_not_nil fee
    assert fee.value == 1.7
    assert fee.feeable_id = correction_1.id
    assert fee.feeable_type = "Correction"
    assert fee.customized_course_id = correction_1.customized_course_id

    fee = correction.fee
    assert_not_nil fee
    assert fee.value == 1
    assert fee.feeable_id = correction.id
    assert fee.feeable_type = "Correction"
    assert fee.customized_course_id = correction.customized_course_id

    assert correction.status == "closed"
    assert correction_1.status == "closed"
    assert Correction.by_teacher(teacher.id).valid_tally_unit.size == 1
  end
end
