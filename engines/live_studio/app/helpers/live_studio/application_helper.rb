module LiveStudio
  module ApplicationHelper
    include ::LiveStudio::SessionsHelper

    # 加权限验证的link_to
    # 链接内容用block调用
    def allow_link_to options, &p
      controller = options[:route] || params[:controller]
      !allow?(controller, options[:action], current_resource(options[:variable])) ? nil :
          link_to(options[:url], options[:sub]) do
            p.present? && p.call
          end
    end

    def preview_time(course, options={})
      date = course.current_lesson.try(:class_date)
      if date
        if date == Date.today
          content_tag(:div, content_tag(:div,"今日 #{course.current_lesson.start_time}"),
                      class: "course-preview matrix #{course.current_lesson.is_over? ? '' : 'preview'}")
        elsif date > Date.today
          text = options[:text2].blank? ? 'distance_text1' : 'distance_text2'
          text = I18n.t("view.course_show.#{text}") % (date - Date.today).to_i
          content_tag(:div, text, class: 'course-preview')
        end
      end
    end

  end
end
