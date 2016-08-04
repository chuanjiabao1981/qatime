module LiveStudio
  module CoursesHelper

    def search_value_show(variable)
      sort = "#{variable}_sort".to_sym
      min = "#{variable}_min".to_sym
      max = "#{variable}_max".to_sym
      return_flag = params[sort].present? ? " [#{t("view.course_search_show.#{variable}_#{params[sort]}")}]" : ''
      if params[min].present? || params[max].present?
        return_flag = " [#{params[min]} ~ #{params[max]}]"
      end
      return_flag
    end

    def search_submit
      button_tag :submit, class: 'btn btn-default search-btn' do
        t('view.course_search_show.submit_value')
      end
    end

    def self_settings
      t('view.course_search_show.self_settings')
    end

    def search_value_show_word(variable)
      params[variable].blank? || params[variable] == 'all' ? '' : " [#{params[variable]}]"
    end
  end
end
