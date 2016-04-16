module Message
  class Image < ActiveRecord::Base
    belongs_to :imagable, polymorphic: true
  end
end
