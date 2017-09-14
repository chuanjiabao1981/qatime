Dir["#{Rails.root}/app/apis/helpers/*.rb", "#{Rails.root}/app/apis/*.rb"].each {|f| require f }

module V2
  module Defaults
    extend ActiveSupport::Concern
    included do
      prefix          "api"
      version         'v2', using: :path
      format          :json
      content_type    :json, 'application/json;charset=UTF-8'
      default_format  :json
      formatter       :json, BodyFormatter
      error_formatter :json, ErrorFormatter
      helpers         APIHelpers

      include         APIErrors
      # 调用接口时验证api_key
      before do
        I18n.locale = 'cn'
      end
    end
  end
end
