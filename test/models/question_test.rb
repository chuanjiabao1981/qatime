require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "question is valid " do
    question = questions(:student1_question1)
    question.valid?
    puts question.errors.full_messages

  end
end
