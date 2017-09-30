module Entities
  module LiveStudio
    class Attachment < Grape::Entity
      expose :id
      expose :file_url
      expose :file_type
    end
  end
end
