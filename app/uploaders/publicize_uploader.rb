# encoding: utf-8
require 'carrierwave/processing/mini_magick'

class PublicizeUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def store_dir
    "courses/publicize/"
  end

  process :resize_to_fit => [480, 480]
  process :crop

  version :info do
    process :resize_to_fill => [480, 300]
  end
  version :list do
    process :resize_to_fill => [320, 200]
  end
  version :small do
    process :resize_to_fill => [160, 100]
  end
  version :app_info do
    process :resize_to_fill => [800, 500]
  end


  def crop
    if model.crop_x.present?
      manipulate! do |img|
        x = model.crop_x.to_i
        y = model.crop_y.to_i
        w = model.crop_w.to_i
        h = model.crop_h.to_i
        Rails.logger.info("#{w}x#{h}+#{x}+#{y}")
        img.crop("#{w}x#{h}+#{x}+#{y}")
        img
      end
    end
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  def default_url
    # For Rails 3.1+ asset pipeline compatibility:
    # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
    "#{APP_CONFIG[:host]}/imgs/course_default.png"
  end

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
  # def filename
  #   "something.jpg" if original_filename
  # end
  def filename
    if original_filename
      # current_path 是 Carrierwave 上传过程临时创建的一个文件，有时间标记，所以它将是唯一的
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      path_elements = original_filename.split('.')
      extension = path_elements.last if path_elements.size > 1

      if not extension.empty?
        "#{@name}.#{extension}"
      else
        "#{@name}.jpg"
      end
    end
  end

end
