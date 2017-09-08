# 答疑时间
module Qatime
  module WillPaginate
    # 异步加载分页结果
    class RemoteLinkRenderer < BootstrapPagination::Rails
      private

      def tag(name, value, attributes = {})
        string_attributes = attributes.inject('') do |attrs, pair|
          unless pair.last.nil?
            attrs << %( #{pair.first}="#{CGI::escapeHTML(pair.last.to_s)}")
          end
          attrs
        end
        return "<#{name}#{string_attributes}>#{value}</#{name}>" unless name == :a
        "<#{name}#{string_attributes} data-remote=true>#{value}</#{name}>"
      end
    end
  end
end
