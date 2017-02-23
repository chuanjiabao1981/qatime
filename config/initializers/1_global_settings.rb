# encoding: utf-8

# >> Settings.messaging.queue_name
# => Exception: Missing setting 'queue_name' in 'message' section in 'application.yml'

# >> Settings.messaging['queue_name']
# => nil

# >> Settings.messaging['queue_name'] ||= 'user_mail'
# => "user_mail"

# >> Settings.messaging.queue_name
# => "user_mail"

class GlobalSettings < Settingslogic
  source "#{Rails.root}/config/global_settings.yml"
  namespace Rails.env
  load!

end
