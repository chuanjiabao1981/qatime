require 'test_helper'

module Chat
  class ChatAccountUpdateTest < ActionDispatch::IntegrationTest
    def setup
      @routes = Engine.routes
      @headless = Headless.new
      @headless.start
      Capybara.current_driver = :selenium_chrome

      @teacher = users(:teacher_with_chat_account)

      account_result = Typhoeus::Response.new(code: 200, body: {code: 200}.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/updateUinfo.action').and_return(account_result)

      uinfos = Typhoeus::Response.new(code: 200, body: {code: 200, uinfos: [{accid: SecureRandom.hex(16), token: SecureRandom.hex(16), name: "new_nick_name", gender: 0}]}.to_json)
      Typhoeus.stub('https://api.netease.im/nimserver/user/getUinfos.action').and_return(uinfos)

      new_log_in_as(@teacher)
    end

    def teardown
      new_logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "update teacher account when teacher update name" do
      visit get_home_url(@teacher)
      click_on "用户设置"
      click_on "安全设置"
      click_on "个人信息"

      click_on "编辑信息", match: :first
      fill_in :teacher_name, with: "new_name"
      fill_in :teacher_nick_name, with: "新昵称"
      click_on "保存"
      @teacher.reload
      Chat::SyncChatAccountJob.perform_now(@teacher.id)

      assert_equal('新昵称', @teacher.chat_account.name, '云信account更新错误')
    end
  end
end
