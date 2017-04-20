module TallyTestHelper

  # block传入的是老师的该类服务待结账的个数
  def keep_account_succeed(teacher, student, workstation, collection, count, class_name, &block)

    assert yield == count
    assert_difference 'EarningRecord.count', count*2, "收入记录生成不正确" do
      assert_difference 'Payment::EarningRecord.count', count*3, "新的收入记录生成不正确" do
        assert_difference 'Payment::EarningRecord.assess_billing.count', count*3, "收入记录不能提现" do
          assert_difference 'Fee.count', count do
            assert_difference 'Payment::Billing.count', count do
              assert_difference 'ConsumptionRecord.count', count do
                collection.each do |object|
                  teacher_money = teacher.account.money
                  student_money = student.account.money
                  workstation_money = workstation.account.money
                  object.keep_account(teacher.id)
                  teacher.account.reload
                  student.account.reload
                  workstation.account.reload

                  student_value, teacher_value, workstation_value = calculate_test_expected_money_change_value(object)

                  assert_equal float_test_format(student_money - student_value), student.account.reload.money, "学生扣费不正确"
                  assert_equal float_test_format(teacher_money + teacher_value), teacher.account.reload.money, "教师收入不正确"
                  assert_equal float_test_format(workstation_money + workstation_value), workstation.account.reload.money, "工作站收入不正确"

                  assert object.is_charged?
                  # 对fee和老师生成的earning_record进行属性测试
                  fee = object.fee
                  assert_not_nil fee
                  assert fee.value                == student_value
                  assert fee.platform_price       == object.platform_price
                  assert fee.teacher_price        == object.teacher_price
                  assert fee.sale_price           == object.platform_price + object.teacher_price
                  assert fee.feeable_id           == object.id
                  assert fee.feeable_type         == class_name
                  assert fee.customized_course_id == object.customized_course_id
                  assert fee.video_duration       == object.video.duration
                end
              end
            end
          end
        end
      end
    end

    assert yield == 0
  end

  def calculate_test_expected_money_change_value(object)
    video = object.video
    if video and video.duration and video.duration > 0
      hours      = Float(video.duration) / 60 / 60
      sale_price = object.teacher_price + object.platform_price
      fee_value  = float_test_format(hours * sale_price)

      teacher_percent, workstation_percent = calculate_test_split_percents(object)
      teacher_value = float_test_format(fee_value * teacher_percent)
      workstation_value = float_test_format(fee_value * workstation_percent)
      [fee_value, teacher_value, workstation_value]
    else
      [0,0,0]
    end
  end

  def calculate_test_split_percents(object)
    teacher_percent = object.teacher_price / (object.teacher_price + object.platform_price)
    workstation_percent = 1 - teacher_percent
    [teacher_percent, workstation_percent]
  end

  def get_expected_customized_course_prices(customized_course)
    if customized_course.category == "高中"
      __get_price(customized_course, APP_CONSTANT["customized_course_senior_high_common_prices"])
    elsif customized_course.category == "初中"
      __get_price(customized_course, APP_CONSTANT["customized_course_junior_high_common_prices"])
    else
      __get_price(customized_course, APP_CONSTANT["customized_course_junior_common_prices"])
    end
  end

  def __get_price(customized_course, price_dict)
    if customized_course.subject
      [price_dict[customized_course.customized_course_type]["teacher_price"],price_dict[customized_course.customized_course_type]["platform_price"]]
    end
  end


  def customized_course_prices_validation(object, &block)
    customized_course = CustomizedCourse.find(object.customized_course_id)

    assert object.save, "#{object.errors.full_messages} #{object.to_json}"
    assert object.valid?

    platform_price = object.platform_price
    teacher_price = object.teacher_price
    assert platform_price == customized_course.platform_price
    assert teacher_price  == customized_course.teacher_price

    yield
    assert object.save

    assert object.platform_price == platform_price
    assert object.teacher_price == teacher_price
  end

  def float_test_format(value)
    format_value = format("%.2f",value).to_f
    format_value
  end
end