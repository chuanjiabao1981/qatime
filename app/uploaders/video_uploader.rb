# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:

  def filename
    if original_filename
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      if not file.extension.empty?
        "#{@name}.#{file.extension}"
      else
        "#{@name}.mp4"
      end
    end
  end


  process :translate

  def translate
    Rails.logger.info("--------" + self.current_path + "--------")
    result = %x(/usr/local/bin/qtfaststart #{self.current_path})
    Rails.logger.info("--------" + result + "--------")

  end

end