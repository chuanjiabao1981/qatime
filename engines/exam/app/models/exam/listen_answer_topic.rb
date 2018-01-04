module Exam
  # 听后回答题
  class ListenAnswerTopic < Exam::Topic
    validates :attach, :title, :answer_attach, presence: true, on: :update
  end
end
