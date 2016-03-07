require 'wechat'
require 'omniauth-wechat-oauth2'

module Qawechat
  class Engine < ::Rails::Engine
    isolate_namespace Qawechat
  end
end
