module Exam
  module Association
    # 学生关联
    module Student
      extend ActiveSupport::Concern

      included do
        has_many :exam_tickets, class_name: 'Exam::Ticket'
        has_many :exam_papers, class_name: 'Exam::Paper', through: :exam_tickets, source: :product, source_type: 'Exam::Paper'
        has_many :exam_results, class_name: 'Exam::Result'
      end
    end
  end
end
