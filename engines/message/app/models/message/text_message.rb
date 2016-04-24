module Message
  class TextMessage < ActiveRecord::Base
    has_one :message, as: :implementable
    belongs_to :author,class_name: User
  end
end
