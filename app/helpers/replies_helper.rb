module RepliesHelper
  def get_reply_form_url(reply,topic)
    if reply.new_record?
      topic_replies_path(topic,anchor:  "new_reply")
    else
      reply_path(reply)
    end
  end
end
