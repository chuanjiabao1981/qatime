class TeachingVideo < ApplicationRecord
  require 'carrierwave/orm/activerecord'
  include ActiveModel::Dirty

  include VideoConvert

  #mount_uploader :name, TeachingVideoUploader
  belongs_to :answer
  belongs_to :teacher
  belongs_to :question

  def self.update_answer_info(answer)
    TeachingVideo.where("token='#{answer.token}'")
    .update_all({answer_id: answer.id,
                 teacher_id: answer.teacher_id,
                 question_id: answer.question_id
                })
  end
end
