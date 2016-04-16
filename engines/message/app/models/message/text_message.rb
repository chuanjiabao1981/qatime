module Message
  class TextMessage < ActiveRecord::Base
    has_one :message, as: :implementable
  end
end
