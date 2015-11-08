class MessageBoard < ActiveRecord::Base
  has_many   :messages
  belongs_to :messageboardable, polymorphic: true
end
