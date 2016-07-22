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
  end
end
