class QaFaq < ActiveRecord::Base
  enum qa_faq_type: { :common => 0 , :student => 1,:teacher => 2}

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if QaFaq.where(token: random_token).size == 0
    end
  end


  after_save :update_picture_info

  private


  def update_picture_info
    Picture.update_imageable_info(self,self.model_name.to_s)
  end
end
