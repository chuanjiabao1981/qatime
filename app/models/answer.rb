class Answer < ActiveRecord::Base
  include Utils::QaToken

  belongs_to :question ,counter_cache: true
  belongs_to :teacher
  validates :content, length: { minimum: 20 }

  #after_create :update_question
  after_save :update_teaching_video,:update_picture_info
  has_many :teaching_videos

  has_many :comments,as: :commentable,dependent: :destroy


  private
  # def update_question
  #   self.question.update_answers_info(self)
  # end

  def update_teaching_video
    TeachingVideo.update_answer_info(self)
  end

  def update_picture_info
    Picture.update_imageable_info(self)
  end
end
