require 'test_helper'

class CustomizedTutorialTest < ActiveSupport::TestCase

  def setup
    @old =     APP_CONSTANT["price_per_minute"]

    APP_CONSTANT["price_per_minute"] = 1
  end

  def teardown
    APP_CONSTANT["price_per_minute"] = @old
  end
  test "customized tutorial valid" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    assert customized_tutorial1.valid?,customized_tutorial1.errors.full_messages
    assert_not_nil customized_tutorial1.video
    assert customized_tutorial1.video.valid?,customized_tutorial1.video.errors.full_messages
  end


  #已经存在一个video,customized tutorial create的时候和此video关联
  test "new customized tutorial with a already exsits video" do
    already_exsits_video  = videos(:teacher1_already_exsits_video)

    customized_course     = customized_courses(:customized_course1)
    customized_tutorial1  = CustomizedTutorial.new(title:"aaaabbbbcccddd",
                                                  customized_course:customized_course,
                                                  teacher: customized_course.teachers.first,
                                                  token:  already_exsits_video.token
    )
    #assert customized_tutorial1.video.new_record? == false

  end

  ###没有video，通过find一定能初始化一个video
  #test "customized tutorial without video" do
  #  tutorial_without_video = customized_tutorials(:customized_tutorial_without_video1)
  #  assert tutorial_without_video.video.new_record?
  #  assert tutorial_without_video.video.videoable_type == CustomizedTutorial.to_s
  #  tutorial_without_video.save
  #  assert tutorial_without_video.video.new_record? == false
  #end
  #有video 通过find一定找到此video
  test "customized tutorial with video" do

    customized_tutorial1   = customized_tutorials(:customized_tutorial1)
    video1    = videos(:teacher1_customize_tutorial_video)


    assert customized_tutorial1.video == video1
  end

  # test "customized course topic reply count" do
  #   customized_tutorial1 = customized_tutorials(:customized_tutorial1)
  #   t                    = topics(:customized_tutorial_topic1)
  #   assert customized_tutorial1.valid?
  #   topic                =  customized_tutorial1.topics.first
  #   assert t.valid?, t.errors.full_messages
  #   r1                   = replies(:customized_tutorial_topic1_reply2)
  # end

  # 测试记账功能
  test "customized tutorial keep_account" do
    #

    teacher = Teacher.find(users(:teacher1).id)
    assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 3

    customized_tutorial = customized_tutorials(:customized_tutorial_test_tally)

    video = videos(:customized_tutorial_test_tally_video)
    assert customized_tutorial.token == video.token
    assert customized_tutorial.valid?,customized_tutorial.errors.full_messages
    assert video.valid?,video.errors.full_messages

    assert_not_nil video
    assert customized_tutorial.video == video

    customized_tutorial.keep_account(teacher.id)
    customized_tutorial_1 = customized_tutorials(:customized_tutorial_test_tally_1)

    customized_tutorial_1.keep_account(teacher.id)

    # 帐号发生了变化
    # 生成了fee
    student = Student.find(users(:student1).id)
    assert teacher.account.money == 2.67
    assert student.account.money == -2.67

    fee = customized_tutorial.fee
    assert_not_nil fee

    assert fee.value == 1.67
    assert fee.feeable_id = customized_tutorial.id
    assert fee.feeable_type = "CustomizedTutorial"
    assert fee.customized_course_id = customized_tutorial.customized_course_id


    fee = customized_tutorial_1.fee
    assert_not_nil fee
    assert fee.value == 1
    assert fee.feeable_id = customized_tutorial_1.id
    assert fee.feeable_type = "CustomizedTutorial"
    assert fee.customized_course_id = customized_tutorial_1.customized_course_id

    assert customized_tutorial.status == "closed"
    assert customized_tutorial_1.status == "closed"
    assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 1
  end

  # test "customized tutorial keep_account transaction" do
  #   teacher = Teacher.find(users(:teacher2).id)
  #   assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 1
  #
  #   customized_tutorial = customized_tutorials(:customized_tutorial_teacher2)
  #
  #   assert_difference 'Fee.count',0 do
  #     begin
  #       customized_tutorial.keep_account_wrong(teacher.id)
  #     rescue ActiveRecord::StatementInvalid => e
  #       customized_tutorial.reload
  #     end
  #
  #     assert teacher.account.money == 0
  #     assert customized_tutorial.status == "open"
  #     student = Student.find(users(:student1).id)
  #     assert student.account.money == 0
  #   end
  #
  #   #这里，因为account的money为空，如果发生加操作，应该会exception，对于exception，需要回滚，所有的操作都必须退回，也就是fee是不能产生的
  #
  # end

  test "customized tutorial keep_account transaction without db" do
    teacher = Teacher.find(users(:teacher2).id)
    assert CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size == 1

    customized_tutorial = customized_tutorials(:customized_tutorial_teacher2)

    assert_difference 'Fee.count',0 do
      begin
        customized_tutorial.keep_account_wrong_not_db(teacher.id)
      rescue ActiveRecord::StatementInvalid => e
        customized_tutorial.reload
      end

      assert teacher.account.money == 0
      assert customized_tutorial.status == "open"
      student = Student.find(users(:student1).id)
      assert student.account.money == 0
    end

    #这里，因为account的money为空，如果发生加操作，应该会exception，对于exception，需要回滚，所有的操作都必须退回，也就是fee是不能产生的

  end
end
