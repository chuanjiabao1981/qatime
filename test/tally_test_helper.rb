module TallyTestHelper

  # block传入的是老师的该类服务待结账的个数
  def keep_account_succeed(teacher, student, collection, count, &block)

    assert yield == count
    assert_difference 'EarningRecord.count', count do
      assert_difference 'Fee.count', count do
        assert_difference 'ConsumptionRecord.count', count do
          collection.each do |object|
            teacher_money = teacher.account.money
            student_money = student.account.money
            object.keep_account(teacher.id)

            teacher.account.reload
            student.account.reload

            fee_value = calculate_test_fee_value(object.video)

            assert teacher.account.money == teacher_money + fee_value
            assert student.account.money == student_money - fee_value

            assert object.status = "closed"

            # 对fee和老师生成的earning_record进行属性测试

            fee = object.fee
            assert_not_nil fee
            assert fee.value == fee_value
            assert fee.feeable_id = object.id
            assert fee.feeable_type = object.class.name
            assert fee.customized_course_id = object.customized_course_id
            assert fee.video_duration = object.video.duration
          end
        end
      end
    end

    assert yield == 0
  end

  def calculate_test_fee_value(video)
    if video and video.duration and video.duration > 0
      minute                 = Float(video.duration) / 60
      fee_value              = format("%.2f",minute * APP_CONSTANT["price_per_minute"]).to_f
      fee_value
    else
      0
    end
  end

end