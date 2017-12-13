module Exam
  module Association
    # 工作站关联
    module Workstation
      extend ActiveSupport::Concern

      included do
        has_many :papers, class_name: 'Exam::Paper'
      end
    end
  end
end
