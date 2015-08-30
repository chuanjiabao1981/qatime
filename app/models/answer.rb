class Answer < ActiveRecord::Base

  include QaToken


  belongs_to :question ,counter_cache: true
  belongs_to :teacher
  validates :content, length: { minimum: 6 }

  has_many :teaching_videos

  has_many :comments,as: :commentable,dependent: :destroy

  has_one :video,as: :videoable
  has_many :pictures,as: :imageable

  def author_id
    self.teacher_id
  end


end
