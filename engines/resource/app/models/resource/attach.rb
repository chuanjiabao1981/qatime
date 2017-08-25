module Resource
  # 资源附件
  class Attach < ActiveRecord::Base
    mount_uploader :file, AttachFileUploader

    validates :file_size, numericality: { only_integer: true, less_than_or_equal_to: 1.gigabytes }
    validates :ext_name, inclusion: { in: %w(pdf doc docx xls xlsx ppt mp4 jpg png zip rar) }

    # 资源文件类型
    def resource_type
      file_ext = ext_name || file.filename.split('.').last.downcase
      case file_ext
      when 'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt'
        Resource::DocumentFile
      when 'mp4'
        Resource::VideoFile
      when 'png', 'jpg'
        Resource::PictureFile
      else
        Resource::OtherFile
      end
    rescue
      nil
    end

    private

    before_validation :set_file_info, if: :file_changed?
    def set_file_info
      return if file.nil?
      self.content_type = file.file.content_type.downcase
      self.file_size = file.file.size
      self.ext_name = file.filename.split('.').last.downcase
    end
  end
end
