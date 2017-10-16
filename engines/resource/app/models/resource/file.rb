module Resource
  class File < ActiveRecord::Base
    belongs_to :directory
    belongs_to :user
    belongs_to :attach, polymorphic: true
    belongs_to :origin, polymorphic: true

    has_many :quotes, dependent: :destroy

    def file_url
      attach.try(:file_url)
    end

    def icon_name
      case ext_name
      when 'mp4'
        'video'
      when 'jpg', 'png'
        'pic'
      when 'pdf'
        'pdf'
      when 'xls', 'xlsx'
        'excel'
      when 'doc', 'docx', 'ppt'
        'word'
      else
        'unknown'
      end
    end
  end
end
