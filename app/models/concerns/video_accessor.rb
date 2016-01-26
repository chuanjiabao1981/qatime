module VideoAccessor
  extend ActiveSupport::Concern

  included do
    has_many :video_quoters, as: :file_quoter, class_name: "VideoQuoter"
    has_many :videos,->{order 'video_quoters.created_at desc'}, through: :video_quoters, class_name: "Video"
    def current_video
      if !self.videos.first.nil?
        self.videos.first
      end
    end
    def new_video_id
      nil
    end
    def new_video_id=(value)
      self.video_ids <<= value
    end
  end
end
