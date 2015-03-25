class Question < ActiveRecord::Base
  belongs_to :student
  has_many :answers
  validates :title, length:{minimum: 10,maximum: 200}
  validates :content, length: { minimum: 20 }
  belongs_to :vip_class,counter_cache: true

  def build_a_answer(teacher_id,attributes={})
    a                 = self.answers.build(attributes)
    a.teacher_id      = teacher_id
    a.token           = self.token
    a
  end
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Question.where(token: random_token).size == 0
    end
  end
end
