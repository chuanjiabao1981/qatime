class Video < ApplicationRecord
  require 'carrierwave/orm/activerecord'
  belongs_to :videoable, polymorphic: true
  belongs_to :author, class_name: "User"
  include VideoConvert

  validates_presence_of :author

  mount_uploader :capture, ::VideoCaptureUploader

  def self.update_videoable_info(videoable_item, videoable_type)
    Video.where("token='#{videoable_item.token}'").update_all(videoable_id: videoable_item.id, videoable_type: videoable_type)
  end

  has_many :video_quoters
  accepts_nested_attributes_for :video_quoters

  # 从网络获取视频时长
  def sync_duration!
    return if name_url.blank?
    real_url = name_url.gsub(/^https/, "http")
    result = `ffprobe -i #{real_url} -show_entries format=duration -v quiet -of csv="p=0"`
    self.duration = result.to_i
    save!
  end

  def sync_info
    return if name_url.blank?
    sync_capture
    sync_duration
    save
  rescue StandardError => e
    Rails.logger.info(e.to_s)
  end

  def format_tmp_duration
    return unless tmp_duration > 0
    tmp = tmp_duration
    second = format('%02d', tmp % 60)
    tmp /= 60
    minute = format('%02d', tmp % 60)
    tmp /= 60
    hour = format('%02d', tmp % 60)
    "#{hour}:#{minute}:#{second}"
  end

  private

  def sync_capture
    real_url = name_url.gsub(/^https/, "http")
    output = "/tmp/" + name_identifier.downcase.gsub(/\.\w+$/, '.jpg')
    %x(~/bin/ffmpeg -i #{real_url} -qscale:v 2 -vframes 1 #{output} 2>&1)
    `ffmpeg         -i #{real_url} -qscale:v 2 -vframes 1 #{output} 2>&1`
    return unless File.exist?(output)
    self.capture = File.open(output)
  end

  def sync_duration
    real_url = name_url.gsub(/^https/, "http")
    result = %x(~/bin/ffprobe -i #{real_url} -show_entries format=duration -v quiet -of csv="p=0" 2>&1)
    self.tmp_duration = result.to_i
  end
end

class VideoChangedWhenConvertingException < Exception
end
