module Entities
  class Software < Grape::Entity
    expose :title
    expose :sub_title
    expose :version
    expose :desc
    expose :description
    expose :download_links
    expose :qr_code_url
    expose :enforce do |_,options|
      options[:enforce]
    end
    expose :running_at
  end
end
