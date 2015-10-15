require 'test_helper'
require 'tally_test_helper'

class CustomizedTutorialTest < ActiveSupport::TestCase
  include TallyTestHelper

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

  test "customized course topic reply count" do
    customized_tutorial1 = customized_tutorials(:customized_tutorial1)
    t                    = topics(:customized_tutorial_topic1)
    assert customized_tutorial1.valid?
    topic                =  customized_tutorial1.topics.first
    assert t.valid?, t.errors.full_messages
    r1                   = replies(:customized_tutorial_topic1_reply2)
  end

  # 测试结账功能
  test "customized tutorial keep_account new" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)

    customized_tutorials = CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit
    keep_account_succeed(teacher, student, customized_tutorials, 5) do
      # 传入待结账的计算方法，用来测试待结账的个数
      CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit.size
    end
  end

  # 将失败处理抽象出来
  def transaction_fail(customized_tutorial, &block)
    teacher = Teacher.find(customized_tutorial.teacher_id)
    customized_course = CustomizedCourse.find(customized_tutorial.customized_course_id)
    student = Student.find(customized_course.student_id)

    teacher_old_money = teacher.account.money
    student_old_money = student.account.money

    assert_difference 'Fee.count',0 do
      begin
        customized_tutorial.keep_account(teacher.id) do
          yield
        end
      rescue ActiveRecord::StatementInvalid => e
        customized_tutorial.reload
      end

      assert teacher.account.money == teacher_old_money
      assert customized_tutorial.status == "open"
      assert student.account.money == student_old_money
    end
  end

  test "customized tutorial keep_account transaction without db" do
    customized_tutorial = customized_tutorials(:customized_tutorial_teacher2)

    transaction_fail(customized_tutorial) do
      raise "Fake Wrong"
    end

    transaction_fail(customized_tutorial) do
      raise ActiveRecord::StatementInvalid, "Fake Wrong"
    end
  end
end
