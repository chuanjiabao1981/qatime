require 'test_helper'
require 'tally_test_helper'

class CustomizedTutorialModelTest < ActiveSupport::TestCase
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

  # 通过专属课堂创建专属课程，价格需要自动设置。修改课程的相关内容，价格不能发生变化
  test "customized tutorial create" do
    customized_course                 = customized_courses(:customized_course1)
    customized_tutorial               = customized_course.customized_tutorials.build
    customized_tutorial.last_operator = customized_course.teachers.first
    customized_tutorial.title         = "test customized tutorial create"
    customized_tutorial.content       = "test customized tutorial create content"
    teacher                           = Teacher.find(users(:teacher1).id)
    customized_tutorial.teacher_id    = teacher.id

    customized_course_prices_validation(customized_tutorial) do
      customized_tutorial.content = "test customized tutorial create content update"
    end
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


  #有video 通过find一定找到此video
  test "customized tutorial with video" do

    customized_tutorial1   = customized_tutorials(:customized_tutorial1)
    video1    = videos(:teacher1_customize_tutorial_video)


    assert customized_tutorial1.video == video1
  end



  # 测试结账功能
  test "customized tutorial keep_account new" do
    teacher = Teacher.find(users(:teacher_tally).id)
    student = Student.find(users(:student_tally).id)
    workstation = workstations(:workstation1)

    customized_tutorials = CustomizedTutorial.by_teacher_id(teacher.id).valid_tally_unit
    keep_account_succeed(teacher, student, workstation, customized_tutorials, 5, "CustomizedTutorial") do
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

  test "customized_tutorial create for count" do
    cc                = customized_courses(:customized_course1)
    ct                = cc.customized_tutorials.build(title: "134123412",content: "contesdafdsfasdf")
    ct.teacher        = cc.teachers.first
    ct.last_operator  = ct.teacher
    assert ct.valid?
    assert_difference 'CustomizedTutorial.count',1 do
      assert_difference 'CustomizedCourseActionRecord.count',1 do
        ##因为有两个老师一个学生所以是
        assert_difference 'CustomizedCourseActionNotification.count',2 do
          ct.save!
        end
      end
    end
  end

  test "customized_tutorial with template video" do
    cc                = customized_tutorials(:customized_tutorial_template_video)
    video             = videos(:video_template)
    video1            = videos(:video_template_1)
    assert cc.valid?
    assert video.valid?
    assert_difference 'VideoQuoter.count',1 do
      cc.template_video = video
      cc.template_video = video1
    end


  end


end
