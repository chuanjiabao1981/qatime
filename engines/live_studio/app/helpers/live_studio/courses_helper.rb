module LiveStudio
  module CoursesHelper

    def search_value_show(variable)
      sort = ''
      if params['sort_by'].present? && params[:sort_by].include?(variable)
        variable = params['sort_by'].split('.').first
        sort = params['sort_by'].split('.').last
      end
      min = "#{variable}_floor".to_sym
      max = "#{variable}_ceil".to_sym
      return_flag = sort.present? ? " [#{t("view.course_search_show.#{variable}_#{sort}")}]" : ''
      if params[min].present? || params[max].present?

        return_flag = sort && sort == 'desc' ? " [#{params[max]} ~ #{params[min]}]" : " [#{params[min]} ~ #{params[max]}]"
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
      flag = variable == 'status' ? t("status.#{params[variable]}") : params[variable]
      params[variable].blank? || params[variable] == 'all' ? '' : " [#{flag}]"
    end
  end
end
