module QaCommonFilter
  extend ActiveSupport::Concern
  class_methods do
    def __add_last_operator_to_param(key)
      before_action do |controller|
        if params[key]
          params[key]["last_operator_id"] = current_user.id
        end
      end
    end
  end
end