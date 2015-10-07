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

  test 'create' do
    @solution = solutions(:homework_solution_one)
    assert @solution.valid?
    assert @solution.first_handle_created_at.nil?
    assert @solution.first_handle_author.nil?
    assert @solution.last_handle_created_at.nil?
    assert @solution.last_handle_author.nil?
    @correction         = @solution.corrections.build(content: "13412341")
    @correction.teacher = @solution.solutionable.teacher
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
    @correction.teacher = @solution.solutionable.teacher
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
    @correction1              = @solution.corrections.build(content: "13412341")
    @correction1.teacher      = @solution.solutionable.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.solutionable.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.solutionable.teacher
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
    @correction1              = @solution.corrections.build(content: "13412341")
    @correction1.teacher      = @solution.solutionable.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.solutionable.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.solutionable.teacher
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
    @correction1              = @solution.corrections.build(content: "13412341")
    @correction1.teacher      = @solution.solutionable.teacher
    @correction1.save
    sleep 1
    @correction2              = @solution.corrections.build(content: "13412x341")
    @correction2.teacher      = @solution.solutionable.teacher
    @correction2.save
    sleep 1
    @correction3              = @solution.corrections.build(content: "13xxxx412341")
    @correction3.teacher      = @solution.solutionable.teacher
    @correction3.save

    @correction1.destroy

    @solution.reload

    assert @solution.first_handle_created_at.to_i       == @correction2.created_at.to_i
    assert @solution.first_handle_author_id             == @correction2.author.id
    assert @solution.last_handle_created_at.to_i        == @correction3.created_at.to_i
    assert @solution.last_handle_author_id              == @correction3.author.id
  end
end
