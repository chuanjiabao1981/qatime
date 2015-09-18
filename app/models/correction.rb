class Correction < ActiveRecord::Base

  include QaToken
  include ContentValidate

  belongs_to  :teacher
  belongs_to  :solution,counter_cache: true
  has_many    :pictures,as: :imageable
  has_one     :video,as: :videoable
  has_many    :comments,-> { order 'created_at asc' },as: :commentable,dependent: :destroy

  def author_id
    self.teacher_id
  end
end
