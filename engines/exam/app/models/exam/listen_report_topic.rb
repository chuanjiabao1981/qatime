module Exam
  # 听后转述题
  class ListenReportTopic < Exam::Topic
    validates :title, :answer_attach, presence: true, on: :update
  end
end
