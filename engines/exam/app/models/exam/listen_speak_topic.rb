module Exam
  # 朗读题
  class ListenSpeakTopic < Exam::Topic
    validates :title, :answer_attach, presence: true, on: :update
  end
end
