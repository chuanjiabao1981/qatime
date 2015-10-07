module QaToken
  extend ActiveSupport::Concern

  CONVERT_POSTFIX='-converted'

  included do
    after_save :__update_picture,:__update_video
    after_initialize :__fill_token
  end

  def generate_token
    self.token = loop do
      random_token = "#{Time.now.to_i}-#{SecureRandom.urlsafe_base64}"
      break random_token if self.class.where(token: random_token).size == 0
    end
  end

  private
  def __update_picture
    if defined? self.pictures
      Picture.update_imageable_info(self)
    end
  end

  def __update_video
    if defined? self.video
      Video.update_videoable_info(self)
    end
  end

  def __fill_token
    if defined? self.video
      self.token = generate_token if self.token == nil
    end

    if defined? self.pictures
      self.token = generate_token if self.token == nil
    end

  end
end