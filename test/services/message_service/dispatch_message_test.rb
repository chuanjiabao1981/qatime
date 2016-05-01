require 'test_helper'
require 'sidekiq/testing/inline'

module MessageServiceTest
  class CreateMessageTest < ActiveSupport::TestCase
    test 'create text message' do
      current_user_id = 1
      options = {
          message_type: 'text_message',
          text_message_content: 'hello world'
      }

      message = MessageService::DispatchMessage.new(current_user_id, options).call
      assert_equal options[:text_message_content], message.implementable.content
    end

    test 'create image message' do
      current_user_id = 1
      image_files = ['test/integration/test.jpg', 'somefilename'];
      images = image_files.map do |image_name|
        image = Message::Image.new
        image.name = image_name
        image.save
        image
      end
      options = {
          message_type: 'image_message',
          image_ids: images.map(&:id)
      }
      message = MessageService::DispatchMessage.new(current_user_id, options).call
      assert_equal images.length, message.implementable.images.length
    end

    test 'create wechat voice message' do
      res = Wechat.api.media_create("voice", "#{Rails.root}/engines/qawechat/test/fixtures/qawechat/voice.amr")
      media_id = res['media_id']

      current_user_id = 1
      options = {
          media_id: media_id
      }

      message = MessageService::DispatchMessage.new(current_user_id, options).call
      assert_equal 'convert_success', message.implementable.state
    end
  end
end
