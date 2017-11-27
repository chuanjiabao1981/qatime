module LiveStudio
  class Quote < ActiveRecord::Base
    belongs_to :attachment
    belongs_to :quoter, polymorphic: true

    delegate :file_url, to: :attachment, prefix: true, allow_nil: true

    validates :attachment, presence: true

    attr_accessor :attachment_file

  end
end
