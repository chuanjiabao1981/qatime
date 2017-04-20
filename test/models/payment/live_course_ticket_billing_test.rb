require 'test_helper'

module Payment
  class LiveCourseTicketBillingTest < ActiveSupport::TestCase

    # 账单计算测试
    test 'test billing money' do
      lesson = live_studio_lessons(:lesson_one_of_billing_course_one)
      ticket = live_studio_tickets(:ticket_three_of_billing_course_one)
      billing = Payment::LiveCourseTicketBilling.new(target: lesson, from_user: lesson.teacher, ticket: ticket)
      billing.calculate
      assert_equal 3, billing.base_fee, "服务费计算错误"
      assert_equal 4.7, billing.platform_money.to_f, "平台收入计算不正确"
      assert_equal 23.5, billing.teacher_money.to_f, "教师收入计算不正确"
      assert_equal 14.1, billing.sell_money, "经销商收入计算不正确"
      assert_equal 4.7, billing.publish_money, "发行商下收入计算不正确"
    end
  end
end
