require 'test_helper'

module MessageServiceTest
  class CreateMessageTest < ActiveSupport::TestCase
    def setup
      super
    end

    test 'create message' do
      options = {
          type: :text,
          params: {
              content: 'hello',
              author_id: 1
          }
      }

      message = MessageServer::CreateMessage.new(options).call
      assert_equal options[:params][:content], message.implementable.content
    end

    test 'create image message' do
      image_files = ['test/integration/test.jpg', 'somefilename'];
      images = image_files.map do |image_name|
        image = Message::Image.new
        image.name = image_name
        image.save
        image
      end

      options = {
        type: :images,
        params: {
          image_ids: images.map(&:id),
          author_id: 1
        }
      }

      message = MessageServer::CreateMessage.new(options).call
      assert message.save
      assert_equal image_files.length, message.implementable.images.count
    end
  end

end
