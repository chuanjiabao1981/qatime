# encoding: utf-8
module LiveStudio
  class AttachmentFileUploader < CarrierWave::Uploader::Base
    def store_dir
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    def default_url
      ActionController::Base.helpers.asset_path("live_studio/attachments/" + [version_name, "default.png"].compact.join('_'))
    end
  end
end
