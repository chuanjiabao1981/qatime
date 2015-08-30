module QaToken
  extend ActiveSupport::Concern

  CONVERT_POSTFIX='-converted'

  included do
    after_save :__update_picture
    after_initialize :__fill_token_and_video_info
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

  def __fill_token_and_video_info
    if defined? self.video
      self.token = generate_token if self.token == nil
      self.video = Video.where(token: self.token).order(created_at: :desc).first

      if self.video.nil?
        self.build_video
        self.video.token = self.token
      end

      self.video.author_id = self.author_id
    end

    if defined? self.pictures
      self.token = generate_token if self.token == nil
    end

  end
end