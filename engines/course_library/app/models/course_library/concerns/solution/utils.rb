module CourseLibrary
  module Concerns   ##在engine下concern没有做特殊处理，这个必须加
    module Solution ##因为在concern下所以不是class
      module Utils extend ActiveSupport::Concern
        included do
          def content
            "#{title}  #{description}"
          end
        end
      end
    end
  end
end

