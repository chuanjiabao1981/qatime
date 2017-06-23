class QaFaq < ActiveRecord::Base
  enum qa_faq_type: { common: 0, student: 1, teacher: 2 }
  include QaToken

  scope :common_teacher, -> { where(qa_faq_type: [qa_faq_types[:common], qa_faq_types[:teacher]]) }
  scope :common_student, -> { where(qa_faq_type: [qa_faq_types[:common], qa_faq_types[:student]]) }
  # def generate_token
  #   self.token = loop do
  #     random_token = SecureRandom.urlsafe_base64
  #     break random_token if QaFaq.where(token: random_token).size == 0
  #   end
  # end
  #
  #
  # after_save :update_picture_info
  #
  # private
  #
  #
  # def update_picture_info
  #   Picture.update_imageable_info(self,self.model_name.to_s)
  # end
end
