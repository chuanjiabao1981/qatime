require 'carrierwave/processing/mini_magick'
module Resource
  class VideoInfoCaptureUploader < CarrierWave::Uploader::Base
    include CarrierWave::MiniMagick

    def store_dir
      "resource/video_infos/capture/"
    end

    # Provide a default URL as a default if there hasn't been a file uploaded:
    def default_url
      ActionController::Base.helpers.asset_path("resource/video_infos/" + [version_name, "capture.png"].compact.join('_'))
    end

    def filename
      return unless original_filename
      @name ||= Digest::MD5.hexdigest(::File.dirname(current_path))
      path_elements = original_filename.split('.')
      extension = path_elements.last if path_elements.size > 1

      if !extension.empty?
        "#{@name}.#{extension}"
      else
        "#{@name}.jpg"
      end
    end
  end
end
