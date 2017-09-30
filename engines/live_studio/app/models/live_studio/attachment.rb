module LiveStudio
  class Attachment < ActiveRecord::Base
    has_many :quotes

    mount_uploader :file, LiveStudio::AttachmentFileUploader

    extend Enumerize

    enumerize :file_type, in: [:jpg, :png, :mp3], predicates: true

    def as_json(options)
      super({ methods: [:file_url] }.merge(options))
    end

    def image?
      jpg? || png?
    end

    def audio?
      mp3?
    end

    private

    before_validation :set_file_type, if: :file_changed?
    def set_file_type
      return if file.nil?
      self.file_type = file.filename.split('.').last.downcase
    end
  end
end
