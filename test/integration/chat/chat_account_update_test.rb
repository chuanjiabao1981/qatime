require 'test_helper'

module LiveStudio
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

      log_in_as(@teacher)
    end

    def teardown
      logout_as(@teacher)
      Capybara.use_default_driver
    end

    test "update teacher account when teacher update nick name" do
      visit edit_teacher_path(@teacher)

      fill_in :teacher_nick_name, with: "new_nick_name"
      click_on "更新信息"
      Chat::SyncChatAccountJob.perform_later(@teacher.id)

      assert_equal('new_nick_name', @teacher.chat_account.name, '云信account更新错误')
    end
  end
end
