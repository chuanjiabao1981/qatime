require File.expand_path('../boot', __FILE__)
require 'csv'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)
APP_CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
APP_CONFIG.symbolize_keys!
APP_GROUP  = YAML.load(File.read(File.expand_path('../group.yml',__FILE__)))
#APP_GROUP.symbolize_keys!
APP_CONSTANT   = YAML.load(File.read(File.expand_path('../constant.yml',__FILE__)))
WECHAT_CONFIG = YAML.load(File.read(File.expand_path('../wechat.yml', __FILE__)))[Rails.env]
# 网易视频云配置
VCLOUD_CONFIG = YAML.load(File.read(File.expand_path('../vcloud.yml', __FILE__)))[Rails.env]
module Qatime
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Beijing'
    I18n.enforce_available_locales = false
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :cn
    config.active_record.raise_in_transactional_callbacks = true
    config.assets.logger = false
    config.active_support.test_order = :sorted

    config.active_job.queue_adapter = :sidekiq

  end
end
