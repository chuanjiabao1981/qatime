require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "question is valid " do
    question = questions(:student1_question1)
    assert question.valid?
  end
end
