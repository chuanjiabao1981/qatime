module Exam
  # 听后记录题
  class ListenWriteTopic < Exam::Topic
    validates :answer, presence: true, on: :update
  end
end
