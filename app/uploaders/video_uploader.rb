# encoding: utf-8

class VideoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :qiniu
  self.qiniu_access_key    = 'ZG5m3UceYSqdxNU4JsMcgTSBZfiI_G9UgHWz2AGv'
  self.qiniu_secret_key    = 'Bh8V5ftV1QgSyRzUElQ6gzssKDm_hrexTBG1YWyC'
  self.qiniu_bucket        = "qatime"
  self.qiniu_bucket_domain = "qatime.qiniudn.com"
  self.persistentOps = "avthumb/mp4;avthumb/m3u8/segtime/15/preset/video_440k"
  self.persistentNotifyUrl = "http://fake.com/qiniu/notify"
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir
  #  "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
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

end
