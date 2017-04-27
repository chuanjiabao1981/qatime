module Payment
  class ItunesProduct < ActiveRecord::Base
    scope :available, -> { where(online: true) }
  end
end
