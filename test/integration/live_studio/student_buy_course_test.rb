require 'test_helper'

module LiveStudio
  class StudentBuyCourseTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome
      @student = ::Student.find(users(:student_with_order2).id)

      account_result = Typhoeus::Response.new(code: 200, body: { code: 200, info: { accid: 'xxxxx', token: 'thisisatoken' } }.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_result)
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test "student buy off shelve course" do
      course = live_studio_courses(:course_for_off_shelve)
      visit live_studio.course_path(course)
      assert page.has_link? '已下架'
      assert page.has_no_link? '立即报名'

      visit live_studio.new_course_order_path(course)
      assert page.has_content? '该课程已下架!'
    end

    test "student buy course" do
      visit live_studio.courses_index_path(student_id: @student)
      course_preview = live_studio_courses(:course_preview)
      assert_difference '@student.orders.count', 1, "辅导班下单失败" do
        visit live_studio.course_path(course_preview)
        click_link '立即报名'
        choose "order_pay_type_weixin"
        click_on '立即支付'
        page.has_content? "遇到支付问题，请拨打电话400-838-8010"
      end
    end

    test "student taste and buy course" do
      course = live_studio_courses(:course_with_lessons)
      visit live_studio.courses_index_path(student_id: @student)
      assert_difference "@student.reload.live_studio_courses.count", 1, "不能正确试听辅导班" do
        assert_difference "@student.reload.live_studio_taste_tickets.count", 1, "不能正确生成试听证" do
          visit live_studio.course_path(course)
          click_on("taste-course-#{course.id}")
          sleep 2
        end
      end
    end

    test "student taste course overflow lessons_count" do
      course = live_studio_courses(:course_for_taste_overflow)
      visit live_studio.course_path(course)
      message = accept_prompt(with: '该试听已失效,请直接购买') do
        click_on '加入试听', match: :first
      end
      assert_equal '该试听已失效,请直接购买', message
    end

    test "student buy tasting course" do
      course = live_studio_courses(:tasting_course)
      visit live_studio.courses_index_path(student_id: @student)
      assert_difference "@student.reload.orders.count", 1, "正在试听的辅导班下单失败" do
        # visit live_studio.new_course_order_path(course)
        # click_on("buy-course-#{course.id}")
        visit live_studio.course_path(course)
        click_link '立即报名'
        choose "order_pay_type_weixin"
        click_on '立即支付'
        sleep(1)
      end
    end

    # 余额支付购买辅导班
    test "buy course with account balance" do
      new_logout_as(@student)
      @student_balance = users(:student_balance)
      new_log_in_as(@student_balance)
      visit live_studio.courses_index_path(student_id: @student_balance)
      @course = live_studio_courses(:course_preview_three)
      assert_difference "@student_balance.cash_account!.reload.balance.to_f", -50, "没有正确扣除余额" do
        assert_difference "@student_balance.cash_account!.reload.total_expenditure.to_f", 50, "总消费计算不正确" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "没有生成消费记录" do
            assert_difference '@student_balance.reload.orders.count', 1, "辅导班下单失败" do
              assert_difference '@course.reload.buy_tickets_count', 1, "购买人数没有增加" do
                visit live_studio.course_path(@course)
                click_link '立即报名'
                choose "order_pay_type_account"
                click_on '立即支付'
                fill_in :payment_password, with: '123123'
                click_on '确认支付'
                sleep 1
              end
            end
          end
        end
      end
      new_logout_as(@student_balance)
      new_log_in_as(@student)
    end

    # 使用优惠码购买辅导班,并验证
    test "student use coupon buy course with account balance" do
      new_logout_as(@student)
      @student_balance = users(:student_balance)
      @coupon_one = payment_coupons(:coupon_one)
      new_log_in_as(@student_balance)
      visit live_studio.courses_index_path(student_id: @student_balance)
      course = live_studio_courses(:course_preview_four)

      visit live_studio.course_path(course)
      click_link '立即报名'
      assert page.has_field?('coupon_code', type: 'text'), "没有优惠码输入框"
      assert page.has_content?('(使用优惠码可立减X元)'), "没有优惠码默认提示语"

      fill_in :coupon_code, with: 'incorrect_code'
      assert page.has_field?('check_coupon_btn', type: 'button'), "优惠码验证button未显示"
      assert page.has_content?('(验证后方可使用)'), "输入优惠码后默认提示语未改变"
      click_on '验证'
      assert page.has_css?('input.active'), "验证按钮未变灰"
      assert page.has_content?('优惠码不正确'), "验证优惠码后未提示错误"

      fill_in :coupon_code, with: 'incorrect_code'
      assert page.has_field?('check_coupon_btn', type: 'button'), "优惠码验证button未显示"
      assert page.has_content?('(验证后方可使用)'), "输入优惠码后默认提示语未改变"
      click_on '验证'
      assert page.has_css?('input.active'), "验证按钮未变灰"
      assert page.has_content?('优惠码不正确'), "验证优惠码后未提示错误"
      assert_equal page.find_by_id('order_total').text.gsub('¥ ', '').to_f, course.current_price, "修改优惠码,应付金额未还原"

      fill_in :coupon_code, with: 'incorrect_code'
      choose "order_pay_type_account"
      message = accept_prompt(with: '请先验证优惠码') do
        click_on '立即支付'
      end
      assert_equal message, "请先验证优惠码"
      click_on '验证'
      message2 = accept_prompt(with: '优惠码不正确') do
        click_on '立即支付'
      end
      assert_equal message2, "优惠码不正确"

      fill_in :coupon_code, with: @coupon_one.code
      assert page.has_field?('check_coupon_btn', type: 'button'), "重新输入优惠码验证button未显示"
      assert page.has_no_css?('input.active'), "重新输入优惠码验证按钮未重置"
      assert page.has_content?('(验证后方可使用)'), "重新输入优惠码后默认提示语未改变"
      click_on '验证'
      assert page.has_css?('input.active'), "验证按钮未变灰"
      assert page.has_content?('通过验证,立减'), "验证优惠码成功后未提示"
      order_total = page.find_by_id('order_total')
      assert_equal order_total.text.gsub('¥ ', '').to_f, course.current_price - @coupon_one.price, "验证优惠码,应付金额未改变"

      assert_difference "@student_balance.cash_account!.reload.balance.to_f", -40, "没有正确扣除优惠余额" do
        assert_difference "@student_balance.cash_account!.reload.total_expenditure.to_f", 40, "优惠总消费计算不正确" do
          assert_difference "Payment::ConsumptionRecord.count", 1, "没有生成消费记录" do
            assert_difference '@student_balance.reload.orders.count', 1, "辅导班下单失败" do
              click_on '立即支付'
              fill_in :payment_password, with: '123123'
              click_on '确认支付'
              sleep 2
            end
          end
        end
      end
      new_logout_as(@student_balance)
      new_log_in_as(@student)
    end

    # 不能试听辅导班
    test "taste count zero" do
      course = live_studio_courses(:course_zero_taste)
      visit live_studio.course_path(course)
      assert_not page.has_content?("加入试听")
    end
  end
end
