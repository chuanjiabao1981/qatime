module Exam
  # 单选题
  class SingleChoiceTopic < Exam::Topic
    attr_accessor :correct_option_count # 正确选项ID个数

    validates :title, presence: true, on: :update

    validate :check_correct_option, on: :update
    def check_correct_option
      errors[:correct_option_count] << '正确选项个数不正确' unless topic_options.select(&:correct).count == 1
    end
  end
end
