module Utils
  module QaToken
    def generate_token
      self.token = loop do
        random_token = "#{Time.now.to_i}-#{SecureRandom.urlsafe_base64}"
        break random_token if self.class.where(token: random_token).size == 0
      end
    end
  end
end