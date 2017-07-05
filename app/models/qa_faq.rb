class QaFaq < ActiveRecord::Base
  include QaToken
  extend Enumerize

  enum qa_faq_type: { common: 0, student: 1, teacher: 2 }
  enumerize :qa_faq_type, in: { common: 0, student: 1, teacher: 2 }

  enum show_type: { faq: 0, static_page: 1, agreement: 2, teacher_usage: 3, student_usage: 4 }
  enumerize :show_type, in: { faq: 0, static_page: 1, agreement: 2, teacher_usage: 3, student_usage: 4 }

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
