require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Wechat2 < Wechat
      option :name, "wechat2"
      option :authorize_params, { scope: "snsapi_base" }
    end
  end
end
