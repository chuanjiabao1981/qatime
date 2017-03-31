module Entities
  class Software < Grape::Entity
    expose :title
    expose :sub_title
    expose :version
    expose :category
    expose :desc
    expose :description
    expose :download_links
    expose :cdn_url
    expose :qr_code_url do |soft|
      soft.qr_code.try(:code_url)
    end
    expose :enforce do |_,options|
      options[:enforce]
    end
    expose :published_at
  end
end
