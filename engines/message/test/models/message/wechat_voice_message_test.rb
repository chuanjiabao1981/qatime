require 'test_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

module Message
  class WechatVoiceMessageTest < ActiveSupport::TestCase
    test '创建微信语音消息' do
      res = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
      media_id = res['media_id']
      voice = Message::WechatVoiceMessage.new
      voice.name = media_id
      assert voice.save
      voice.reload
      assert_equal 'not_convert', voice.state

      voice.in_queue!
      voice.reload
      assert_equal 'convert_success', voice.state
    end
  end
end
