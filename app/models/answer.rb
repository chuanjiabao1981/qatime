class Answer < ActiveRecord::Base
  belongs_to :question ,counter_cache: true
  belongs_to :teacher
  validates :content, length: { minimum: 20 }

  after_create :update_question

  private
  def update_question
    self.question.update_answers_info(self)
  end
end
