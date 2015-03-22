class Question < ActiveRecord::Base
  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64
      break random_token if Topic.where(token: random_token).size == 0
    end
  end
end
