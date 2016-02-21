module CourseLibrary
  module Concerns   ##在engine下concern没有做特殊处理，这个必须加
    module CoursePublication ##因为在concern下所以不是class
      module Common extend ActiveSupport::Concern
        included do
          after_create :__publish_to_customized_course
          def __publish_to_customized_course
            CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(self).call
          end
        end
      end
    end
  end
end

