module Entities
  class Software < Grape::Entity
    expose :title
    expose :sub_title
    expose :version
    expose :desc
    expose :description
    expose :download_links
    expose :qr_code_url do |soft|
      soft.qr_code.try(:code_url)
    end
    expose :enforce do |_,options|
      options[:enforce]
    end
    expose :running_at
  end
end
