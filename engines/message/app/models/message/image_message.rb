module Message
  class ImageMessage < ActiveRecord::Base
    has_many :images, as: :imagable
    has_one :message, as: :implementable
    belongs_to :author,class_name: User
  end
end
