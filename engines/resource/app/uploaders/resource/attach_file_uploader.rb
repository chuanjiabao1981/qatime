# encoding: utf-8
module Resource
  class AttachFileUploader < CarrierWave::Uploader::Base
    def store_dir
      "upload/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
