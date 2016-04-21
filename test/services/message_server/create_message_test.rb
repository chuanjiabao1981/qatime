require 'test_helper'

module MessageServerTest
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
      image_files = ['test/integration/test.jpg'];
      images = image_files.map do |image|
        path = Rails.root.join(image)
        Rack::Test::UploadedFile.new(path, "image/jpeg")
      end

      options = {
        type: :images,
        params: {
          images: images,
          author_id: 1
        }
      }

      message = MessageServer::CreateMessage.new(options).call
      assert message.save
      assert_equal 1, message.implementable.images.count
    end
  end

end
