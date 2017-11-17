module Social
  class Feed < ActiveRecord::Base
    belongs_to :feedable, polymorphic: true
    belongs_to :producer, polymorphic: true
    belongs_to :target, polymorphic: true
    belongs_to :linkable, polymorphic: true
    belongs_to :workstation

    has_many :feed_publishs

    include Social::FeedSubscribale
  end
end
