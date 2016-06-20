module LiveStudio
  class ApplicationController < ::ApplicationController
    layout 'live_studio/layouts/application'

    def i18n_notice(type, model)
      t("activerecord.successful.messages.#{type}", model: model.class.model_name.human)
    end
  end
end
