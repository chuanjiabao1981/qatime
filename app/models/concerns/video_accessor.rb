module VideoAccessor
  extend ActiveSupport::Concern

  included do
    has_many :video_quoters, as: :file_quoter, class_name: "VideoQuoter"
    has_many :videos,->{order 'created_at desc'}, through: :video_quoters, class_name: "Video"
    def current_video
      self.videos.first
    end
  end
end
