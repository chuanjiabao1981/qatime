# encoding: utf-8

class TeachingVideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:

  def filename
    if original_filename
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))

      path_elements = original_filename.split('.')
      extension = path_elements.last if path_elements.size > 1


      if not extension.empty?
        "#{@name}.#{extension}"
      else
        "#{@name}.mp4"
      end
    end
  end

  def store_dir
    "videos/"
  end

  def extension_white_list
    %w(mp4)
  end

  process :translate

  def translate
    result = %x(/usr/local/bin/qtfaststart #{self.current_path})
  end

end
