class Video < ActiveRecord::Base
  require 'carrierwave/orm/activerecord'
  belongs_to :lesson
  include ActiveModel::Dirty


  #这些是不是要和teaching_video合并
  mount_uploader :name, VideoUploader
  mount_uploader :convert_name,VideoUploader

  CONVERT_POSTFIX='-converted'

  before_save :check_if_need_convert
  after_save

  def build_convert_file_name
    return "#{File.basename(self.name_identifier,File.extname(name_identifier))}#{CONVERT_POSTFIX}.mp4"
  end

  state_machine :initial => :wait_convert do
    transition :converting                => :convert_success,:on => [:convert_process_finish]
    transition :convert_success            => :wait_convert,:on => [:re_convert]
    event :convert_process_begin do
      transition all - [:converting,:convert_success] => :converting
    end
    event :convert_process_exec_error do
      transition all => :convert_fail
    end
  end

  private
  def check_if_need_convert
    self.state = :wait_convert if self.name_changed?
  end
end