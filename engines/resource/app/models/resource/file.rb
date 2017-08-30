module Resource
  class File < ActiveRecord::Base
    belongs_to :directory
    belongs_to :user
    belongs_to :attach, polymorphic: true

    has_many :quotes, dependent: :destroy

    def file_url
      attach.try(:file_url)
    end
  end
end
