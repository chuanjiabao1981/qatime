module Message
  class ImageMessage < ActiveRecord::Base
    has_many :images, as: :imagable
    has_one :message, as: :implementable
  end
end
