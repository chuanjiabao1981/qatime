require 'test_helper'

module Payment
  class LiveCourseBillingTest < ActiveSupport::TestCase
    # 测试计算金额
    test 'test calculate' do
      lesson = live_studio_lessons(:lesson_one_of_course_for_billing_one)
      billing = Payment::LiveCourseBilling.new(target: lesson)
      billing.calculate
      assert_equal 250.0, billing.total_money.to_f, "结账金额不正确"
    end
  end
end
