class TicketToken
  def self.instance_token(obj, cate)
    token = SecureRandom.urlsafe_base64
    Redis.current.setex("#{obj.model_name.cache_key}/#{obj.id}/#{cate}", 5 * 60, token)
    token
  end

  def self.get_instance_token(obj, cate)
    Redis.current.get("#{obj.model_name.cache_key}/#{obj.id}/#{cate}")
  end
end
