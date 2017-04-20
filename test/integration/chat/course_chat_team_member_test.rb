require 'test_helper'

module Chat
  class CourseChatTeamMemberTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      @student = users(:student1)
      team_results = Array.new(10) { Typhoeus::Response.new(code: 200, body: { status: 200, tid: SecureRandom.hex(16) }.to_json)}
      Typhoeus.stub('https://api.netease.im/nimserver/team/create.action').and_return(team_results)
      account_results = Array.new(10) { Typhoeus::Response.new(code: 200, body: { status: 200, info: { accid: SecureRandom.hex(16), token: SecureRandom.hex(16) } }.to_json)}
      Typhoeus.stub('https://api.netease.im/nimserver/user/create.action').and_return(account_results)
      join_results = Array.new(10) { Typhoeus::Response.new(code: 200, body: { code: 200 }.to_json)}
      Typhoeus.stub('https://api.netease.im/nimserver/team/add.action').and_return(join_results)
      Capybara.current_driver = :selenium_chrome
      new_log_in_as(@student)
    end

    def teardown
      new_logout_as(@student)
      Capybara.use_default_driver
    end

    test 'student taste course join team' do
      course = live_studio_courses(:course_for_taste)
      visit live_studio.courses_path
      assert_difference "course.taste_tickets.count", 1, "试听失败" do
        visit live_studio.course_path(course)
        click_link("taste-course-#{course.id}")
        Chat::TeamMemberCreatorJob.perform_now(course.id, @student.id)
        @student.reload
        course.reload
      end
      assert_not_nil @student.chat_account, "学生没有创建云信ID"
      assert_not_nil course.reload.chat_team, "没有自动创建聊天群组"
      assert course.chat_team.accounts.includes(@student.chat_account), "没有正确加入群组"
    end

    test 'student buy course join team' do
      order_response =
        "<xml>
          <return_code><![CDATA[SUCCESS]]></return_code>
          <return_msg><![CDATA[OK]]></return_msg>
          <appid><![CDATA[#{WxPay.appid}]]></appid>
          <mch_id><![CDATA[#{WxPay.mch_id}]]></mch_id>
          <nonce_str><![CDATA[IITRi8Iabbblz1Jc]]></nonce_str>
          <sign><![CDATA[7921E432F65EB8ED0CE9755F0E86D72F]]></sign>
          <result_code><![CDATA[SUCCESS]]></result_code>
          <prepay_id><![CDATA[wx201411101639507cbf6ffd8b0779950874]]></prepay_id>
          <trade_type><![CDATA[NATIVE]]></trade_type>
          </xml>"

      FakeWeb.register_uri(:post, "https://api.mch.weixin.qq.com/pay/unifiedorder", body: order_response)

      notify_body = {
        appid: WxPay.appid, 
        attach: "支付测试",
        bank_type: "CFT",
        fee_type: "CNY",
        is_subscribe: "Y",
        mch_id: WxPay.mch_id,
        nonce_str: "5d2b6c2a8db53831f7eda20af46e531c",
        openid: "oUpF8uMEb4qRXf22hE3X68TekukE",
        result_code: "SUCCESS",
        return_code: "SUCCESS",
        time_end: Time.now.to_i,
        total_fee: "20000",
        trade_type: "NATIVE",
        transaction_id: "1004400740201409030005092168"
      }

      course = live_studio_courses(:course_for_tasting)
      visit live_studio.courses_path
      assert_difference "course.buy_tickets.count", 1, "购买失败" do
        visit live_studio.course_path(course)
        click_link '立即报名'
        # click_link("buy-course-#{course.id}")
        choose('微信支付')
        click_on '立即支付'
        transaction_no = page.find('#transaction_no').text
        notify_body[:out_trade_no] = transaction_no
        notify_body[:sign] = WxPay::Sign.generate(notify_body)

        post payment.notify_transaction_path(transaction_no), notify_body.to_xml(root: 'xml', dasherize: false)
        Chat::TeamMemberCreatorJob.perform_now(course.id, @student.id)
        @student.reload
        course.reload
      end
      assert_not_nil @student.chat_account, "学生没有创建云信ID"
      assert_not_nil course.reload.chat_team, "没有自动创建聊天群组"
      assert course.chat_team.accounts.includes(@student.chat_account), "没有正确加入群组"
    end
  end
end
