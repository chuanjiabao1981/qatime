require 'test_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

module Qawechat
  class WechatVoiceTest < ActiveSupport::TestCase
    test "create wechat voice" do
      res = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
      media_id = res['media_id']
      voice = Qawechat::WechatVoice.new
      voice.name = media_id
      assert voice.save
      voice.reload
      assert_equal 'not_convert', voice.state

      voice.in_queue!
      voice.reload
      assert_equal 'convert_success', voice.state
    end

    test 'convert fail' do
      voice = Qawechat::WechatVoice.new
      voice.name = 'some faker media_id'
      assert voice.save

      voice.reload
      assert_equal 'not_convert', voice.state

      voice.in_queue!
      voice.reload
      assert_equal 'convert_fail', voice.state
    end

  end
end
