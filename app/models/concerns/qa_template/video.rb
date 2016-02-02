module QaTemplate
  module Video extend ActiveSupport::Concern
    included do
      has_one    :video_quoter,as: :file_quoter,dependent: :destroy
      has_one    :template_video,through: :video_quoter,source: :video
    end

    def video
      return template_video if template_video
      if defined? :video
        return super
      end
    end
  end
end