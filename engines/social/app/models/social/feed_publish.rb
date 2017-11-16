module Social
  class FeedPublish < ActiveRecord::Base
    belongs_to :feed
    belongs_to :publisher, polymorphic: true
  end
end
