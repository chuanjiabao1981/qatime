module Message
  class Message < ActiveRecord::Base
    belongs_to :messagable, polymorphic: true
    belongs_to :implementable, polymorphic: true
  end
end
