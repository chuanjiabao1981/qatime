module Entities
  class AppInfo < Grape::Entity
    expose :name
    expose :category
    expose :version
    expose :level
    expose :description
    expose :download_url
    expose :qr_code_url
    expose :enforce do |_,options|
      options[:enforce]
    end
    expose :running_at
  end
end
