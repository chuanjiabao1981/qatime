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
      course = live_studio_courses(:course_for_tasting)
      visit live_studio.courses_path
      assert_difference "course.buy_tickets.count", 1, "购买失败" do
        visit live_studio.course_path(course)
        click_link '立即报名'
        # click_link("buy-course-#{course.id}")
        choose('微信支付')
        click_on '立即付款'
        # TODO 不能正确模拟支付通知
        # post payment.notify_transaction(Payment::Order.last.transaction_no, )
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
