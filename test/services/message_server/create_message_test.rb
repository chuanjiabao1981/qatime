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

  end

end
