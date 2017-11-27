module Chat
  class JoinRecord < ActiveRecord::Base
    delegate :name, :accid, :icon, to: :account

    enum role: { student: 0, teacher: 1, manager: 2 }

    belongs_to :account
    belongs_to :team

    def role_text
      I18n.t("enumerize.#{model_name.i18n_key}.role.#{role}")
    end
  end
end
